#include "mainwindow.h"
#include <QPushButton>
#include <QVBoxLayout>
#include <QWidget>
#include "version.h"

MainWindow::MainWindow(QWidget *parent)
    : QMainWindow(parent)
{
    QWidget *central = new QWidget(this);
    setCentralWidget(central);

    QVBoxLayout *layout = new QVBoxLayout(central);
    
    m_label = new QLabel("Hello Qt with VS Code!", this);
    m_label2 = new QLabel(, this);
    QPushButton *button = new QPushButton("Click me", this);
    
    layout->addWidget(m_label);
    layout->addWidget(m_label2);
    layout->addWidget(button);
    
    connect(button, &QPushButton::clicked, this, &MainWindow::onButtonClicked);
}

void MainWindow::onButtonClicked()
{
    m_label->setText("Button clicked!");
}