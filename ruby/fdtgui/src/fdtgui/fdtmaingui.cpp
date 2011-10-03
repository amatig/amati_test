#include "fdtmaingui.h"
#include "ui_fdtmaingui.h"

FdtMainGui::FdtMainGui(QWidget *parent) :
    QMainWindow(parent),
    ui(new Ui::FdtMainGui)
{
    ui->setupUi(this);
}

FdtMainGui::~FdtMainGui()
{
    delete ui;
}
