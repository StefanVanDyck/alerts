package au.org.ala.alerts

import com.jayway.jsonpath.JsonPath
import com.jayway.jsonpath.PathNotFoundException
import grails.converters.JSON
import org.grails.web.json.JSONArray
import org.grails.web.json.JSONObject

import java.text.SimpleDateFormat


class AnnotationService {
    def httpService
    def sdf = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss")  // Adjust the pattern as needed

    String appendAssertions(Query query, JSONObject occurrences) {
        String baseUrl = query.baseUrl

        if(occurrences.occurrences) {
            // reconstruct occurrences so that only those records with specified annotations are put into the list
            JSONArray reconstructedOccurrences = []
            for (JSONObject occurrence : occurrences.occurrences) {
                if (occurrence.uuid) {
                    // all the verified assertions of this occurrence record

                    String assertionUrl = baseUrl + '/occurrences/' + occurrence.uuid + '/assertions'
                    def assertionsData = httpService.get(assertionUrl)
                    JSONArray assertions = JSON.parse(assertionsData) as JSONArray

                    def sortedAssertions = assertions.sort { a, b ->
                                sdf.parse(b.created) <=> sdf.parse(a.created)
                            }
                    occurrence.put('user_assertions', sortedAssertions)
                    reconstructedOccurrences.push(occurrence)
                }
            }
            reconstructedOccurrences.sort { it.uuid }

            // reconstruct occurrences which will be used to retrieve diff (records that will be included in alert email)
            occurrences.put('occurrences', reconstructedOccurrences)
        }

        return occurrences.toString()
    }

    /**
     * If fireNotZero property is true, diff method will not be called
     *
     * for normal alerts, comparing occurrence uuid is enough to show the difference.
     * for my annotation alerts, same occurrence record could exist in both result but have different assertions.
     * so comparing occurrence uuid is not enough, we need to compare 50001/50002/50003 sections inside each occurrence record

     * return a list of records that their annotations have been changed or deleted
     * @param previous
     * @param last
     * @param recordJsonPath
     * @return
     */
    def diff(previous, last, recordJsonPath) {
        // uuid -> occurrence record map
        def oldRecordsMap = [:]
        def curRecordsMap = [:]
        try {
            oldRecordsMap = JsonPath.read(previous, recordJsonPath).collectEntries { [(it.uuid): it] }
        }catch (PathNotFoundException e){
            log.warn("Previous result is empty or doesn't have any records containing a field ${recordJsonPath} defined in recordJsonPath")
        }
        try {
             curRecordsMap = JsonPath.read(last, recordJsonPath).collectEntries { [(it.uuid): it] }
        }catch (PathNotFoundException e){
            log.warn("Current result is empty or doesn't have any records containing a field ${recordJsonPath} defined in recordJsonPath")
        }
        // if an occurrence record doesn't exist in previous result (added) or has different open_assertions or verified_assertions or corrected_assertions than previous (changed).
        def records = curRecordsMap.findAll {
            def record = it.value
            def previousRecord = oldRecordsMap.get(record.uuid)
            if (previousRecord) {
                String currentAssertions = JSON.stringify(filterAssertions(record.user_assertions))
                String previousAssertions = JSON.stringify(filterAssertions(previousRecord.user_assertions))
                currentAssertions || previousAssertions
            } else {
                true
            }
        }.values()


        //if an occurrence record exists in previous result but not in current, it means the annotation is deleted.
        //We need to add these records as a 'modified' record
        records.addAll(oldRecordsMap.findAll { !curRecordsMap.containsKey(it.value.uuid) }.values())

        return records
    }
}
