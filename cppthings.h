#ifndef CPPTHINGS
#define CPPTHINGS

#include <QDir>

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
        system("rm -rf /home/nemo/Books/test1.pdb");
        system("rm -rf /home/nemo/Books/test1.pdb");
        return true;
    }
};

#endif // CPPTHINGS

