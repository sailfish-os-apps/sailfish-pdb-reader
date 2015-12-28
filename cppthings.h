#ifndef CPPTHINGS
#define CPPTHINGS

#include <QDir>
#include "exec.h"

class CPPthings: public QObject {
    Q_OBJECT
public:
    Q_INVOKABLE bool mkbasedir(const QString name) const {
        bool created = false; // wether the dir was created during this run
        QDir dir("/home/nemo/"+name); // creates base folder based on localization
        if(!dir.exists()) {
            dir.mkpath(".");
            created = true;
        }
        QString base("Books"); // base english name
        if(base == name || created == false) { // if it is the same, no need to copy files, or if it was not created right now
            return true;
        }
        QDir base_dir("/home/nemo/Books");
        if(base_dir.exists()) { // if it was created before the localization to this language came
            std::string c_name = name.toStdString();
            std::string command = "cp /home/nemo/Books/* /home/nemo/"+c_name;
            system(command.c_str());
            system("rm -rf /home/nemo/Books");
        }
        return true;
    }

    Q_INVOKABLE QStringList listbooks(const QString name) const {
        QDir dir("/home/nemo/"+name);
        QStringList filters;
        filters << "*.pdb" << "*.epub";
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
        std::string command = "uchardet \"/home/nemo/.config/harbour-pdb-reader/"+c_book+"\"";
        return QString::fromStdString(exec(command.c_str())).trimmed();
    }

    Q_INVOKABLE bool makeTxt(const QString book, const QString name) const {
        QFileInfo file("/home/nemo/.config/harbour-pdb-reader/"+book+".txt");
        if(file.exists()) {
            return true;
        }
        std::string c_book = book.toStdString();
        std::string c_name = name.toStdString();
        std::string command = "txt2pdbdoc -d -D \"/home/nemo/"+c_name+"/"+c_book+"\" > \"/home/nemo/.config/harbour-pdb-reader/"+c_book+".txt\"";
        system("mkdir -p /home/nemo/.config/harbour-pdb-reader");
        system(command.c_str());
        return true;
    }

    Q_INVOKABLE bool reencode(const QString book,const QString source_encoding) const {
        system("mkdir -p /home/nemo/.config/harbour-pdb-reader/utf8");

        std::string c_source_encoding = source_encoding.toStdString();
        std::string c_book = book.toStdString();

        std::string command0 = "chmod 0777 \"/home/nemo/.config/harbour-pdb-reader/utf8/"+c_book+".txt\"";
        system(command0.c_str());

        std::string command = "iconv -f \""+c_source_encoding+"\" -t \"utf-8\" \"/home/nemo/.config/harbour-pdb-reader/"+c_book+".txt\" > \"/home/nemo/.config/harbour-pdb-reader/utf8/"+c_book+".txt\"";
        system(command.c_str());

        std::string command2 = "chmod 0444 \"/home/nemo/.config/harbour-pdb-reader/utf8/"+c_book+".txt\"";
        system(command2.c_str());

        return true;
    }

    Q_INVOKABLE QString getBookContents(const QString book) const {
        std::string c_book = book.toStdString();
        std::string command = "cat \"/home/nemo/.config/harbour-pdb-reader/utf8/"+c_book+".txt\"";
        return QString::fromStdString(exec(command.c_str()));
    }

    Q_INVOKABLE QString listEncodings() const {
        return QString::fromStdString(exec("iconv -l"));
    }

    Q_INVOKABLE bool clearDatabase() const {
        system("rm -rf /home/nemo/.config/harbour-pdb-reader/*");
        return true;
    }
};

#endif // CPPTHINGS

