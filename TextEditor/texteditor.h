#ifndef TEXTEDITOR_H
#define TEXTEDITOR_H

#include <QMainWindow>
#include <QPlainTextEdit>
#include <QStringList>
#include <QSignalMapper>

namespace Ui {
class TextEditor;
}

#define MAX_RECENT_FILES 20

class TextEditor : public QMainWindow
{
    Q_OBJECT

public:
    explicit TextEditor(QWidget *parent = 0);
    ~TextEditor();

protected:
    void closeEvent(QCloseEvent *event) Q_DECL_OVERRIDE;

private:
    void createActions();
    void createMenus();
    void createToolBars();
    void createStatusBars();

    void setCurrentFile(const QString & fileName);
    void loadFile(const QString &fileName);
    bool maybeSave();
    bool saveFile(const QString &fileName);

    void writeSettings();
    void readSettings();
    void buildRecentFileMenuItems();

signals:

private slots:
    void newFile();
    void open();
    bool save();
    bool saveAs();
    void about();
    void documentWasModifed();
    void openRecentFiles();

private:
    Ui::TextEditor *ui;
    QPlainTextEdit *mTextEditor;
    QString mCurFile;
    // Recent files
    QMenu *mRecentMenu;
    QAction *mRecentFileActs[MAX_RECENT_FILES];

    // Menu bar
    QMenu *mFileMenu;
    QMenu *mEditMenu;
    QMenu *mHelpMenu;
    // Toolbar
    QToolBar *mFileBar;
    QToolBar *mEditBar;
    // File Menu
    QAction *mNewAct;
    QAction *mOpenAct;
    QAction *mSaveAct;
    QAction *mSaveAsAct;
    QAction *mExitAct;
    // Edit Menu
    QAction *mCopyAct;
    QAction *mCutAct;
    QAction *mPasteAct;
    // About Menu
    QAction *mAboutAct;
    QAction *mAboutQtAct;
};

#endif // TEXTEDITOR_H
