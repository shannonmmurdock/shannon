/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class DB_WebServices {
    global DB_WebServices() {

    }
    webService static void bypassBlock() {

    }
    webService static void cancelKeyBuilding() {

    }
    webService static Integer deleteAllOldScenarioLinksBatch() {
        return null;
    }
    webService static String deleteAllScenarioKeysBatchApex(Integer batchSize) {
        return null;
    }
    webService static Integer deleteAllScenarioLinksBatch() {
        return null;
    }
    webService static Integer deleteOldScenarioLinksBatch(List<String> scenarios) {
        return null;
    }
    webService static String deleteScenarioKeysBatchApex(List<String> scenarios, Integer batchSize) {
        return null;
    }
    webService static Integer deleteScenarioLinksBatch(List<String> scenarios) {
        return null;
    }
    webService static String getDupeBlockerStatus(String requestingFeature) {
        return null;
    }
    @ReadOnly
    webService static Integer getKeysCount(String scenarioIds) {
        return null;
    }
    webService static List<Id> getPotentialDupeObjectIdsByWarningId(String dupeWarningId) {
        return null;
    }
    @ReadOnly
    webService static Integer getRecordCount(String objectName) {
        return null;
    }
    webService static List<String> getSettings() {
        return null;
    }
    webService static String getVersion() {
        return null;
    }
    webService static void incrementScenarioBlockCount(String scenarioId, Integer blockCount) {

    }
    webService static void incrementScenarioMergeCount(String scenarioId, Integer mergeCount) {

    }
    webService static Boolean isValidLicense() {
        return null;
    }
    webService static void leadConvert_CreateTask(String contactId, String opportunityId, String subject, String description) {

    }
    webService static void markScenariosRebuildNeeded(List<String> scenarioIds) {

    }
    webService static void markScenariosRebuilt(List<String> scenarioIds) {

    }
    webService static List<String> rebuildKeysBatchApex(List<String> scenarioIds, String objectType, Integer batchSize) {
        return null;
    }
    webService static Integer rebuildKeys_Account(Id scenarioId, List<String> idArray) {
        return null;
    }
    webService static Integer rebuildKeys_Contact(Id scenarioId, List<String> idArray) {
        return null;
    }
    webService static Integer rebuildKeys_Lead(Id scenarioId, List<String> idArray) {
        return null;
    }
    webService static Integer rebuildKeys(Id scenarioId, List<String> idArray, String objectType) {
        return null;
    }
    webService static void saveSettings(List<String> settings) {

    }
    webService static void setScenarioKeySizes(List<String> scenarioIds, List<Integer> keySizes) {

    }
    webService static String updateLicense(String requestingFeature, Integer userCount) {
        return null;
    }
    webService static String validateLicense(String requestingFeature, Integer userCount) {
        return null;
    }
    webService static String validateLicenseWithoutCount(String requestingFeature) {
        return null;
    }
}
