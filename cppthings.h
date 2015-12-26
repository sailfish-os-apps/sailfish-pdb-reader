#ifndef CPPTHINGS
#define CPPTHINGS

#include <QDir>
#include "exec.h"

class CPPthings: public QObject {
    Q_OBJECT
public:
    Q_INVOKABLE bool mkbasedir(const QString name) const {
        QDir dir("/home/nemo/"+name);
        if(!dir.exists()) {
            return dir.mkpath(".");
        }
        return true;
    }

    Q_INVOKABLE QStringList listbooks(const QString name) const {
        QDir dir("/home/nemo/"+name);
        QStringList filters;
        filters << "*.pdb";
        dir.setNameFilters(filters);
        return dir.entryList();
    }

    Q_INVOKABLE bool mkFakeBooks() const {
        system("touch /home/nemo/Books/test1.pdb");
        system("touch /home/nemo/Books/test2.pdb");
        system("touch /home/nemo/Books/test3.pdb");
        return true;
    }

    Q_INVOKABLE bool rmFakeBooks() const {
        system("rm -rf /home/nemo/Books/test1.pdb");
        system("rm -rf /home/nemo/Books/test2.pdb");
        system("rm -rf /home/nemo/Books/test3.pdb");
        return true;
    }

    Q_INVOKABLE QString getEncoding(const QString book) const {
        std::string c_book = book.toStdString();
        std::string command = "uchardet /home/nemo/.config/harbour-pdb-reader/"+c_book;
        return QString::fromStdString(exec(command.c_str())).trimmed();
    }

    Q_INVOKABLE bool makeTxt(const QString book, const QString name) const {
        QFileInfo file("/home/nemo/.config/harbour-pdb-reader/"+book+".txt");
        if(file.exists()) {
            return true;
        }
        std::string c_book = book.toStdString();
        std::string c_name = name.toStdString();
        std::string command = "txt2pdbdoc -d -D /home/nemo/"+c_name+"/"+c_book+" > /home/nemo/.config/harbour-pdb-reader/"+c_book+".txt";
        system("mkdir -p /home/nemo/.config/harbour-pdb-reader");
        system(command.c_str());
        return true;
    }

    Q_INVOKABLE bool reencode(const QString book,const QString source_encoding) const {
        system("mkdir -p /home/nemo/.config/harbour-pdb-reader/utf8");
        std::string c_source_encoding = source_encoding.toStdString();
        std::string c_book = book.toStdString();
        std::string command = "iconv -f \""+c_source_encoding+"\" -t \"utf-8\" /home/nemo/.config/harbour-pdb-reader/"+c_book+".txt > /home/nemo/.config/harbour-pdb-reader/utf8/"+c_book+".txt";
        system(command.c_str());
        return true;
    }

    Q_INVOKABLE QString getBookContents(const QString book) const {
        std::string c_book = book.toStdString();
        std::string command = "cat /home/nemo/.config/harbour-pdb-reader/utf8/"+c_book+".txt";
        return QString::fromStdString(exec(command.c_str()));
    }
};

#endif // CPPTHINGS

