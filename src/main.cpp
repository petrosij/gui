#include <QApplication>
#include <QPushButton>
#include "version.h"

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    QPushButton versionButton;
    QFont const buttonFont("Courier");
    QIcon buttonIcon ("../images/icon_mri.jpg");
    versionButton.setText(PROJECT_VERSION);
    versionButton.setToolTip("The version of the application");
    versionButton.setFont(buttonFont);
    versionButton.setIcon(buttonIcon);
    versionButton.show();

    return app.exec();
}