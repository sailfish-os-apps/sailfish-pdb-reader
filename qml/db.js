function open() {
    var db = LocalStorage.openDatabaseSync("PDBreaderDB","1.0","Database", 1000000);
    return db;
}

function firstrun() {
    ct.mkbasedir(qsTr("Books"));
}
