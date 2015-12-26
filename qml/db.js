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

function changeMode(mode) {
    if(mode == "book") {
        base1.visible = false;
        book1.visible = true;
        book2.visible = true;
        book3.visible = true;
    } else {
        book1.visible = false;
        book2.visible = false;
        book3.visible = false;
        base1.visible = true;
        pageheader.title = qsTr("PDB book reader");
        textarea.text = welcometext;
        position = 0;
        current_book = "";
        current_visible_text = "";
        current_whole_text = "";
        book_opened = false;
    }
}
