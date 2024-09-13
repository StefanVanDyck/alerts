<%@ page contentType="text/html"%>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="org.apache.commons.lang3.StringUtils" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${title}</title>
</head>
<body style="background-color: #f4f4f4;margin: 0;padding: 0;font-family: 'Arial', sans-serif;font-size: 16px;line-height: 1.5;">
<table border="0" cellpadding="0" cellspacing="0" width="100%" style="font-family: 'Arial', sans-serif;font-size: 16px;line-height: 1.5;border-spacing: 0;border-collapse: collapse;">
    <tr>
        <td align="center" style="padding: 20px;font-family: 'Arial', sans-serif;font-size: 16px;line-height: 1.5;">
            <table border="0" cellpadding="0" cellspacing="0" width="620" style="background-color: #ffffff;font-family: 'Arial', sans-serif;font-size: 16px;line-height: 1.5;border-spacing: 0;border-collapse: collapse;">
                <!-- Logo -->
                <tr>
                    <td align="center" style="padding: 20px; font-family: 'Arial', sans-serif;font-size: 16px;line-height: 1.5;">
%{--                        <!--[if gte mso 9]>--}%
%{--                        <v:image xmlns:v="urn:schemas-microsoft-com:vml" fill="true" stroke="false" style=" border: 0;display: inline-block; width: 480pt; height: 300pt;" src="https://via.placeholder.com/640x400" />--}%
%{--                        <v:rect xmlns:v="urn:schemas-microsoft-com:vml" fill="true" stroke="false" style=" border: 0;display: inline-block;position: absolute; width: 480pt; height:300pt;">--}%
%{--                            <v:fill  opacity="0%" color="#000000”  />--}%
%{--                        <v:textbox inset="0,0,0,0">--}%
%{--                        <![endif]-->--}%
                        <a href="https://www.ala.org.au" target="_blank" style="font-family: 'Arial', sans-serif;font-size: 16px;line-height: 1.5;">
                            <img src="${grailsApplication.config.grails.serverURL + '/assets/email/logo-dark.png'}" height="60" alt="Logo" style="display: block;border: 0;line-height: 100%;">
                        </a>
                    </td>
                </tr>
                <!-- Header -->
                <tr>
                    <td align="center" bgcolor="#B73D2D" background="${grailsApplication.config.grails.serverURL}/assets/email/biosecurity-alert-header.png" width="620" height="120"  style="color:white;background-color: #ffffff;padding: 20px;text-align: center;font-family: 'Arial', sans-serif;font-size: 16px;line-height: 1.5;background:url(${grailsApplication.config.grails.serverURL}/assets/email/biosecurity-alert-header.png);">
                        <h1 style="font-size: 24px; color: #fff;">Biosecurity Alerts</h1>
                        <p style="font-size: 16px; color: #fff;"><strong>${new SimpleDateFormat("dd MMMM yyyy").format(new Date())}</strong></p>
                        <p style="font-size: 16px; color: #fff;">Alerts service for new ALA records listing potential invasive species</p>
                    </td>
                </tr>
                <!-- Records Section -->
                <g:each status="i" in="${records}" var="oc">
                <g:set var="link" value="${query.baseUrlForUI}/occurrences/${oc.uuid}"></g:set>
                <tr>
                    <td style="padding: 20px;background-color: white;font-family: 'Arial', sans-serif;font-size: 16px;line-height: 1.5;">
                        <table border="0" cellpadding="0" cellspacing="0" width="100%" style="font-family: 'Arial', sans-serif;font-size: 16px;line-height: 1.5;border-spacing: 0;border-collapse: collapse;">
                            <tr>
                                <td width="50%" valign="top" style="font-family: 'Arial', sans-serif;font-size: 16px;line-height: 1.5;">
                                    <a href="${query.baseUrlForUI}/occurrences/${oc.uuid}" style="color: #C44D34;text-decoration: none;font-family: 'Arial', sans-serif;font-size: 16px;line-height: 1.5;">
                                        <strong>${i+1}. <em>${oc.scientificName ?: 'N/A'}</em></strong>
                                    </a>
                                    <p style="font-size: 13px; color: #212121;">
                                        <g:if test="${oc.scientificName && oc.raw_scientificName && oc.scientificName != oc.raw_scientificName}">
                                            Supplied as:<em>${oc.raw_scientificName}</em><br>
                                        </g:if>
                                        <g:if test="${oc.vernacularName}">
                                            Common name: ${oc.vernacularName}<br>
                                        </g:if>
                                        <g:if test="${oc.locality && oc.stateProvince}">
                                            <strong>${oc.locality}; ${oc.stateProvince}</strong>><br>
                                        </g:if>
                                        <g:elseif test="${oc.locality}">
                                            <strong>${oc.locality}</strong><br>
                                        </g:elseif>
                                        <g:elseif test="${oc.stateProvince}">
                                            <strong>${oc.stateProvince}</strong><br>
                                        </g:elseif>
                                        <g:if test="${oc.latLong}">
                                            Coordinates: ${oc.latLong} <br>
                                        </g:if>
                                        <g:if test="${oc.eventDate}">
                                            Time & date: ${new SimpleDateFormat('dd-MM-yyyy HH:mm').format(oc.eventDate)} <br>
                                        </g:if>
                                        <g:if test="${oc.dataResourceName}">
                                            Source: ${oc.dataResourceName} <br>
                                        </g:if>
                                    </p>
                                </td>
                                <td width="50%" valign="top" style="font-family: 'Arial', sans-serif;font-size: 16px;line-height: 1.5;">
                                    <a href="https://www.google.com/maps/place/${oc.latLong}" target="_blank" style="font-family: 'Arial', sans-serif;font-size: 16px;line-height: 1.5;">
                                        <img src="https://maps.googleapis.com/maps/api/staticmap?center=${oc.latLong}&markers=|${oc.latLong}&zoom=12&size=130x118&maptype=roadmap&key=${grailsApplication.config.getProperty('google.apikey')}" alt="Map Image" style="width: 130px;height: 118px;display: block;border: 0;line-height: 100%;">
                                    </a>
                                </td>
                                <td>
                                    <div class="species-thumbnail-div" style="vertical-align: top;max-width: 130px;width: 130px;height: 118px;border-radius: 6px;">
                                        <g:if test="${oc.thumbnailUrl || oc.smallImageUrl }">
                                            <a href="${query.baseUrlForUI}/occurrences/${oc.uuid}">
                                                <div class="species-thumbnail-div" style="background-image: url('${oc.thumbnailUrl ?: oc.smallImageUrl}');background-size: cover;background-position: center;vertical-align: top;max-width: 130px;width: 130px;height: 118px;border-radius: 6px;"></div>
                                            </a>
                                        </g:if>
                                        <g:else>
                                            <div class="missing-species-thumbnail-div" style="vertical-align: top;max-width: 130px;width: 130px;height: 118px;border-radius: 6px;background-image: url(${grailsApplication.config.grails.serverURL}/assets/email/no-img-gray-bg.png);"> </div>
                                        </g:else>
                                    </div>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                </g:each>
                <!-- Footer Section -->
                <tr>
                    <td style="padding: 20px 70px 14px 70px;background-color: #C44D34;color: #fff;font-family: 'Arial', sans-serif;font-size: 14px;line-height: 1.43;text-align: center;">
                        <p>If you notice a record has been misidentified, we encourage you to use your expertise to improve the quality of Australia's biosecurity data.</p>
                        <p>Please either annotate the record in the provider platform itself or notify us at <a href="mailto:biosecurity@ala.org.au" style="color: #f2f2f2; font-weight: 700;">biosecurity@ala.org.au</a> for assistance.</p>
                    </td>
                </tr>
                <tr>
                    <td style="padding: 20px 70px 14px 70px;background-color: #000000;color: #fff;font-family: 'Arial', sans-serif;font-size: 14px;line-height: 1.43;;text-align: center;">
                        <p>The Atlas of Living Australia acknowledges Australia's Traditional Owners and pays respect to the past and present Elders of the nation's Aboriginal and Torres Strait Islander communities.</p>
                        <p>We honour and celebrate the spiritual, cultural and customary connections of Traditional Owners to Country and the biodiversity that forms part of that Country.</p>
                    </td>
                </tr>
                <tr>
                    <td style="padding: 20px 70px 14px 70px;background-color: #ffffff;color: #000;font-family: 'Arial', sans-serif;font-size: 14px;line-height: 1.43;;text-align: center;">
                        <img src="${grailsApplication.config.grails.serverURL}/assets/email/ncris.png" alt="Affiliated orgs" usemap="#orgsMap" height="80" style="border: 0;line-height: 100%;outline: 0;">
                        <map name="orgsMap">
                            <area shape="rect" coords="0,0,100,100" href="https://www.education.gov.au/ncris" alt="NCRIS">
                            <area shape="rect" coords="100,0,180,100" href="https://csiro.au" alt="CSIRO">
                            <area shape="rect" coords="180,0,300,100" href="https://www.gbif.org/" alt="GBIF">
                        </map>
                        <p>You are receiving this email because you opted in to ALA alerts.
                            <div>
                                <p>Our mailing address is: </p>
                                Atlas of Living Australia <br> GPO Box 1700<br> Canberra, ACT 2601<br>Australia
                            </div>
                            <br>
                            Don't want to receive these emails? You can <a href="${unsubscribeOne}" style="color: #C44D34;">unsubscribe</a>.
                        </p>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
</table>
</body>
</html>
