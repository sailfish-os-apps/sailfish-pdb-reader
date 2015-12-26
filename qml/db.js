function open() {
    var db = LocalStorage.openDatabaseSync("PDBreaderDB","1.0","Database", 1000000);
    return db;
}

function firstrun() {
    ct.mkbasedir(qsTr("Books"));
    ct.mkFakeBooks();
}

function initBook(book, encoding) {
    open().transaction(function(tx) {
        tx.executeSql("INSERT INTO books (original_name,position,encoding) VALUES (?,?,?)",[book,0,encoding]);
    });
}
