#include <QtQuick>
#include <QDebug>
#include <sailfishapp.h>
#include "exec.h"
#include "cppthings.h"


int main(int argc, char *argv[])
{
    CPPthings ct;
    QGuiApplication *app = SailfishApp::application(argc, argv);
    QQuickView *view = SailfishApp::createView();
    QString qml = QString("qml/harbour-pdb-reader.qml");
    view->rootContext()->setContextProperty("ct",&ct);
    view->setSource(SailfishApp::pathTo(qml));
    view->show();
    return app->exec();
}

std::string exec(const char* cmd) {
    FILE* pipe = popen(cmd, "r");
    if (!pipe) return "ERROR";
    char buffer[128];
    std::string result = "";
    while(!feof(pipe)) {
        if(fgets(buffer, 128, pipe) != NULL)
            result += buffer;
    }
    pclose(pipe);
    return result;
}
