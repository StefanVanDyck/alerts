package ala.postie

class NotificationController {

    def notificationService
    def emailService
    def userService
    def authService

    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

    def myalerts = { redirect(action: "myAlerts", params: params) }

    def myAlerts = {

      User user = userService.getUser()
      println('Viewing my alerts :  ' + user)

      //enabled alerts
      def notificationInstanceList = Notification.findAllByUser(user)

      //split into custom and non-custom...
      def enabledQueries = notificationInstanceList.collect { it.query }
      def enabledIds =  enabledQueries.collect { it.id }

      //all types
      def allAlertTypes = Query.findAllByCustom(false)

      allAlertTypes.removeAll { enabledIds.contains(it.id) }
      def customQueries = enabledQueries.findAll { it.custom }
      def standardQueries = enabledQueries.findAll { !it.custom }
      
      println("customQueries: " + customQueries.size())

      [disabledQueries:allAlertTypes, enabledQueries:standardQueries, customQueries:customQueries, frequencies:Frequency.listOrderByPeriodInSeconds(), user:user]
    }

    def addMyAlert = {
      log.debug('add my alert '+ params.id)
      def notificationInstance = new Notification()
      notificationInstance.query =  Query.findById(params.id)
      notificationInstance.user = userService.getUser()
      //does this already exist?
      def exists = Notification.findByQueryAndUser(notificationInstance.query, notificationInstance.user)
      if(!exists){
        notificationInstance.save(flush: true)
      }
      return null
    }

    def deleteMyAlert = {

      def user = userService.getUser()
      def query = Query.get(params.id)
      log.debug('Deleting my alert :  ' + params.id + ' for user : ' + authService.username())

      def notificationInstance = Notification.findByUserAndQuery(user, query)
      if (notificationInstance) {
        log.debug('Deleting my notification :  ' + params.id)
        notificationInstance.each { it.delete(flush: true) }
      } else {
        log.error('*** Unable to find  my notification - no delete :  ' + params.id)
      }
      return null
    }

    def deleteMyAlertWR = {
      def user = userService.getUser()

      //this is a hack to get around a CAS issue
      if(user == null){
        user = User.findByEmail(params.userId)
      }

      def query = Query.get(params.id)
      log.debug('Deleting my alert :  ' + params.id + ' for user : ' + authService.username())

      def notificationInstance = Notification.findByUserAndQuery(user, query)
      if (notificationInstance) {
        log.debug('Deleting my notification :  ' + params.id)
        notificationInstance.each { it.delete(flush: true) }
      } else {
        log.error('*** Unable to find  my notification - no delete :  ' + params.id)
      }
      redirect(action:'myAlerts')
    }

    def changeFrequency = {
        def user = userService.getUser()
        log.debug("Changing frequency to: " + params.frequency)
        user.frequency = ala.postie.Frequency.findByName(params.frequency)
        user.save(true)
        return null
    }

    def checkNow = {
      Notification notification = Notification.get(params.id)
      boolean sendUpdateEmail = notificationService.checkStatus(notification.query)
      if(sendUpdateEmail){
        emailService.sendNotificationEmail(notification)
      }
      redirect(action: "show", params: params)
    }

    def index = {
      //if is ADMIN, then index page
      //else redirect to /notification/myAlerts
      if(authService.userInRole("ADMIN")){
        redirect(action: "admin")
      } else {
        redirect(action: "myAlerts")
      }
    }

    def admin = {

    }
}
