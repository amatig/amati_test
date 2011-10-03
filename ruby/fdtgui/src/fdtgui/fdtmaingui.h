#ifndef FDTMAINGUI_H
#define FDTMAINGUI_H

#include <QMainWindow>

namespace Ui {
    class FdtMainGui;
}

class FdtMainGui : public QMainWindow
{
    Q_OBJECT

public:
    explicit FdtMainGui(QWidget *parent = 0);
    ~FdtMainGui();

private:
    Ui::FdtMainGui *ui;
};

#endif // FDTMAINGUI_H
