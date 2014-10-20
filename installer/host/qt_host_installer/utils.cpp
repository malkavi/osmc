#include "utils.h"
#include <QString>
#include <QDateTime>
#include <QFile>
#include <QFileInfo>
#include <QTextStream>
#include <QDebug>
#include <QTranslator>
#include <QApplication>
#include <QMessageBox>
#include "supporteddevice.h"
#include <QList>
#include <QDir>
#include <QMessageBox>
#ifdef Q_OS_LINUX
#include <unistd.h>
#endif

namespace utils
{
    void writeLog(QString strLog)
    {
        QFile logFile(QDir::homePath() + "/" + "log.txt");
        QDateTime timestamp = QDateTime::currentDateTime();
        logFile.open(QIODevice::Append);
        if (logFile.isOpen())
        {
#ifdef Q_OS_LINUX
            // Set the owner and group the same as the home path
            QFileInfo info(QDir::homePath());
            fchown(logFile.handle(),info.ownerId(),info.groupId());
#endif
            QTextStream logStream(&logFile);
            logStream << timestamp.toString() << " " << strLog << '\n';
            logFile.close();
        }
        else
        {
            qDebug() << timestamp.toString() << " " << strLog;
        }
    }

    void displayError(QString title, QString message, bool isCritical)
    {
        QMessageBox *errorMessageBox = new QMessageBox();
        errorMessageBox->setWindowTitle(title);
        errorMessageBox->setText(message);
        errorMessageBox->setStandardButtons(QMessageBox::Ok);
        if (isCritical)
        {
            errorMessageBox->setIcon(QMessageBox::Critical);
        }
        errorMessageBox->exec();
    }


    bool promptYesNo(QString title, QString question)
    {
        QMessageBox *questionBox = new QMessageBox();
        questionBox->setWindowTitle(title);
        questionBox->setText(question);
        questionBox->setStandardButtons(QMessageBox::Yes | QMessageBox::No);

        if (questionBox->exec() == QMessageBox::Yes)
            return true;
        else
            return false;
    }

    QList<SupportedDevice * > buildDeviceList()
    {
        utils::writeLog("Enumerating supported devices");
        QList<SupportedDevice * > devices;
        SupportedDevice *RBP = new SupportedDevice("Raspberry Pi", "RBP", true, true, true, false, true, false);
        devices.append(RBP);
        return devices;
    }

    bool validateIp(QString ip)
    {
        if (ip.isNull() || ip.isEmpty())
            return false;

        QStringList elements = ip.split(".");
        for (int i = 0; i < elements.count(); i++)
        {
            QString element = elements.at(i);
            if (element.isEmpty() || element.toInt() < 0 || element.toInt() > 255)
                return false;
        }

        return true;
    }

}
