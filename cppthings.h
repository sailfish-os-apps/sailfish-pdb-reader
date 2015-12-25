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
        filters << "*.pdb" << "*.txt";
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
        system("rm -rf /home/nemo/Books/test1.pdb");
        system("rm -rf /home/nemo/Books/test1.pdb");
        return true;
    }

    Q_INVOKABLE QString getEncoding(const QString book, const QString name) const {
        std::string c_book = book.toStdString();
        std::string c_name = name.toStdString();
        std::string command = "uchardet /home/nemo/"+c_name+"/"+c_book;
        return QString::fromStdString(exec(command.c_str())).trimmed();
    }
};

#endif // CPPTHINGS

