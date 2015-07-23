#include "texteditor.h"
#include "ui_texteditor.h"

#include <QFileDialog>
#include <QMessageBox>
#include <QTextStream>
#include <QFileInfo>
#include <QSettings>

TextEditor::TextEditor(QWidget *parent) :
    QMainWindow(parent),
    ui(new Ui::TextEditor)
{
    ui->setupUi(this);

    mTextEditor = new QPlainTextEdit();
    this->setCentralWidget(mTextEditor);

    createActions();
    createMenus();
    buildRecentFileMenuItems();
    createToolBars();
    createStatusBars();

    readSettings();

    connect(mTextEditor->document(), SIGNAL(contentsChanged()), this, SLOT(documentWasModifed()));
    setCurrentFile(mCurFile);
}

TextEditor::~TextEditor()
{
    delete ui;
}

void TextEditor::createStatusBars()
{
    statusBar()->showMessage(tr("Ready"));
}

void TextEditor::createToolBars()
{
    mFileBar = addToolBar(tr("File"));
    mFileBar->addAction(mNewAct);
    mFileBar->addAction(mOpenAct);
    mFileBar->addAction(mSaveAct);

    mEditBar = addToolBar(tr("Edit"));
    mEditBar->addAction(mCutAct);
    mEditBar->addAction(mCopyAct);
    mEditBar->addAction(mPasteAct);
}

void TextEditor::createMenus()
{
    mFileMenu = menuBar()->addMenu(tr("&File"));
    mFileMenu->addAction(mNewAct);
    mFileMenu->addAction(mOpenAct);
    mFileMenu->addAction(mSaveAct);
    mFileMenu->addAction(mSaveAsAct);
    mFileMenu->addSeparator();
    mRecentMenu = mFileMenu->addMenu(tr("&Recent"));
    for (int i = 0; i < MAX_RECENT_FILES; i ++) {
        mRecentMenu->addAction(mRecentFileActs[i]);
    }
    mFileMenu->addSeparator();
    mFileMenu->addAction(mExitAct);

    mEditMenu = menuBar()->addMenu(tr("&Edit"));
    mEditMenu->addAction(mCutAct);
    mEditMenu->addAction(mCopyAct);
    mEditMenu->addAction(mPasteAct);

    mHelpMenu = menuBar()->addMenu(tr("&Help"));
    mHelpMenu->addAction(mAboutAct);
    mHelpMenu->addAction(mAboutQtAct);
}

void TextEditor::createActions()
{
    mNewAct = new QAction(QIcon("://images/copy.png"), tr("&New"), this);
    mNewAct->setShortcut(QKeySequence::New);
    mNewAct->setStatusTip(tr("Create a new file"));
    mNewAct->connect(mNewAct, &QAction::triggered, this, &TextEditor::newFile);

    mOpenAct = new QAction(QIcon("://images/open.png"), tr("&Open"), this);
    mOpenAct->setShortcut(QKeySequence::Open);
    mOpenAct->setStatusTip(tr("Open a exist file"));
    mOpenAct->connect(mOpenAct, &QAction::triggered, this, &TextEditor::open);

    mSaveAct = new QAction(QIcon("://images/save.png"), tr("&Save"), this);
    mSaveAct->setShortcut(QKeySequence::Save);
    mSaveAct->setStatusTip(tr("save file to disk"));
    mSaveAct->connect(mSaveAct, &QAction::triggered, this, &TextEditor::save);

    mSaveAsAct = new QAction(QIcon("://images/save.png"), tr("Save &As ..."), this);
    mSaveAsAct->setShortcut(QKeySequence::SaveAs);
    mSaveAsAct->setStatusTip(tr("save file under a new name"));
    mSaveAsAct->connect(mSaveAsAct, &QAction::triggered, this, &TextEditor::saveAs);

    mExitAct = new QAction(tr("E&xit"), this);
    mExitAct->setShortcut(QKeySequence::Quit);
    mExitAct->setStatusTip(tr("exist the application"));
    mExitAct->connect(mExitAct, SIGNAL(triggered()), this, SLOT(close()));

    mCutAct = new QAction(QIcon("://images/cut.png"), tr("Cu&t"), this);
    mCutAct->setShortcut(QKeySequence::Cut);
    mCutAct->setStatusTip(tr("cut current selection to clipboard"));
    mCutAct->connect(mCutAct, SIGNAL(triggered()), mTextEditor, SLOT(cut()));

    mCopyAct = new QAction(QIcon("://images/copy.png"), tr("&Copy"), this);
    mCopyAct->setShortcut(QKeySequence::Copy);
    mCopyAct->setStatusTip(tr("copy current selection to clipboard"));
    mCopyAct->connect(mCopyAct, SIGNAL(triggered()), mTextEditor, SLOT(copy()));

    mPasteAct = new QAction(QIcon("://images/paste.png"), tr("&Paste"), this);
    mPasteAct->setShortcut(QKeySequence::Paste);
    mPasteAct->setStatusTip(tr("paste the cotent of clipboard to current cursor"));
    mPasteAct->connect(mPasteAct, SIGNAL(triggered()), mTextEditor, SLOT(paste()));

    mAboutAct = new QAction(tr("&About"), this);
    mAboutAct->setStatusTip(tr("show application's about box"));
    mAboutAct->connect(mAboutAct, &QAction::triggered, this, &TextEditor::about);

    mAboutQtAct = new QAction(tr("&About &Qt"), this);
    mAboutQtAct->setStatusTip(tr("about Qt"));
    mAboutQtAct->connect(mAboutQtAct, SIGNAL(triggered()), qApp, SLOT(aboutQt()));

    mCutAct->setEnabled(false);
    mCopyAct->setEnabled(false);

    for (int i = 0; i < MAX_RECENT_FILES; i ++) {
        mRecentFileActs[i] = new QAction(this);
        mRecentFileActs[i]->setVisible(false);
        connect(mRecentFileActs[i], SIGNAL(triggered()), this, SLOT(openRecentFiles()));
    }

    mTextEditor->connect(mTextEditor, SIGNAL(copyAvailable(bool)), mCutAct, SLOT(setEnabled(bool)));
    mTextEditor->connect(mTextEditor, SIGNAL(copyAvailable(bool)), mCopyAct, SLOT(setEnabled(bool)));
}

void TextEditor::openRecentFiles()
{
    if (maybeSave()) {
        QAction *act = qobject_cast<QAction *>(sender());
        if (act) {
            loadFile(act->data().toString());
        }
    }
}

void TextEditor::buildRecentFileMenuItems()
{
    QSettings settings;
    QStringList files = settings.value("recentFiles").toStringList();

    int num = qMin(files.size(), MAX_RECENT_FILES);

    for (int i = 0; i < num; i ++) {
        QFileInfo file(files[i]);
        QString text = tr("&%1. %2").arg(i).arg(file.fileName());
        mRecentFileActs[i]->setText(text);
        mRecentFileActs[i]->setData(files[i]);
        mRecentFileActs[i]->setVisible(true);
    }
    for (int i = num; i < MAX_RECENT_FILES; i ++) {
        mRecentFileActs[i]->setVisible(false);
    }
}

void TextEditor::writeSettings()
{
    QSettings settings("sfox.com", "Text Editor");
    settings.setValue("pos", this->pos());
    settings.setValue("size", this->size());
}

void TextEditor::readSettings()
{
    QSettings settings("sfox.com", "Text Editor");
    move(settings.value("pos", QPoint(200, 200)).toPoint());
    resize(settings.value("size", QSize(400, 400)).toSize());
}

void TextEditor::closeEvent(QCloseEvent *event)
{
    if (maybeSave()) {
        writeSettings();
        event->accept();
    } else {
        event->ignore();
    }
}

void TextEditor::documentWasModifed()
{
    setWindowModified(mTextEditor->document()->isModified());
}

bool TextEditor::saveFile(const QString &fileName)
{
    QFile file(fileName);
    if (!file.open(QFile::WriteOnly | QFile::Text)) {
        QMessageBox::warning(this, tr("TextEditor"),
                             tr("Failed to write file %s:\n%s")
                             .arg(fileName)
                             .arg(file.errorString()));
        return false;
    }

    QTextStream out(&file);
#ifndef QT_NO_CURSOR
    QApplication::setOverrideCursor(Qt::WaitCursor);
#endif
    out << mTextEditor->toPlainText();
#ifndef QT_NO_CURSOR
    QApplication::restoreOverrideCursor();
#endif

    setCurrentFile(fileName);
    statusBar()->showMessage(tr("file saved"), 2000);
    return true;
}

void TextEditor::setCurrentFile(const QString & fileName)
{
    mCurFile = fileName;
    mTextEditor->document()->setModified(false);
    setWindowModified(false);

    QString title = mCurFile.isEmpty() ? tr("untitled.txt") : QFileInfo(mCurFile).fileName();
    title += tr("[*] - TextEditor");
    setWindowTitle(title);

    if (!fileName.isEmpty()) {
        QSettings settings;
        QStringList recentFiles = settings.value("recentFiles").toStringList();
        recentFiles.removeAll(fileName);
        recentFiles.prepend(fileName);
        while (recentFiles.count() > MAX_RECENT_FILES) {
            recentFiles.removeLast();
        }
        settings.setValue("recentFiles", recentFiles);

        buildRecentFileMenuItems();
    }
}

void TextEditor::loadFile(const QString &fileName)
{
    QFile file(fileName);
    if (!file.open(QFile::ReadOnly | QFile::Text)) {
        QMessageBox::warning(this, tr("TextEditor"), tr("Cannot read file %1:\n%2").arg(fileName).arg(file.errorString()));
        return;
    }

    QTextStream in(&file);
#ifndef QT_NO_CURSOR
    QApplication::setOverrideCursor(Qt::WaitCursor);
#endif
    mTextEditor->setPlainText(in.readAll());
    file.close();
#ifndef QT_NO_CURSOR
    QApplication::restoreOverrideCursor();
#endif

    setCurrentFile(fileName);
    statusBar()->showMessage(tr("file loaded"), 2000);
}

bool TextEditor::maybeSave()
{
    if (mTextEditor->document()->isModified()) {
        QMessageBox::StandardButton ret;
        ret = QMessageBox::warning(this, tr("TextEditor"),
                                   tr("The document has been modified.\nDo you want to save changes?"),
                                   QMessageBox::Save | QMessageBox::Discard | QMessageBox::Cancel);
        if (ret == QMessageBox::Save) {
            return save();
        } else if (ret == QMessageBox::Cancel) {
            return false;
        }
    }
    return true;
}

void TextEditor::newFile()
{
    if (maybeSave()) {
        mTextEditor->clear();
        mCurFile = "";
        setCurrentFile(mCurFile);
    }
}

void TextEditor::open()
{
    if (maybeSave()) {
        QString fileName = QFileDialog::getOpenFileName(this);
        if (!fileName.isEmpty()) {
            loadFile(fileName);
        }
    }
}

bool TextEditor::save()
{
    if (mCurFile.isEmpty()) {
        return saveAs();
    } else {
        return saveFile(mCurFile);
    }
}

bool TextEditor::saveAs()
{
    QString fileName = QFileDialog::getSaveFileName(this,
                                                    tr("TextEditor"),
                                                    mCurFile,
                                                    tr("Text Files (*.txt);; All Files (*.*)"));
    if (!fileName.isEmpty()) {
        return saveFile(fileName);
    }
    return false;
}

void TextEditor::about()
{
    QMessageBox::about(this,
                       tr("About Text Editor"),
                       tr("This is an demo application created by Qt to implement Text Editor"));
}

