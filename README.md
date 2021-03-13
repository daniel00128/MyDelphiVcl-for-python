# MyDelphiVcl for python
![1.png](img/1.png)

參考python4delphi提供之demo程式， 使用delphi開發的python package，增加delphi使用者熟悉之MessageDlg 函數，給python GUI使用者呼叫及使用。

---
## 開發環境

+ 作業系統:windows 10
+ delphi : dx 10.3
+ python : v3.8 32位元


## 參考網址:
+ [pythongui.org](https://pythongui.org/python-for-delphi-vcl-vs-tkinter/)
+ [python4delphi](https://github.com/pyscripter/python4delphi)

### python 原始碼

``` python
from MyDelphiVCL import Form,Application
from MyDelphiVCL import FreeConsole,caFree,IDCANCEL,IDOK
from MyDelphiVCL import CreateComponent
from MyDelphiVCL import mbOK,mbCancel,mtConfirmation,mrOk,MessageDlg

from datetime import datetime

class MainForm(Form):
 
    def __init__(self, Owner=None):
        self.FOwner =Owner
        self.Caption = "MyDemo DelphiVCL For Python."
        self.SetBounds(10, 10, 500, 400)
        self.BorderStyle='bsDialog'
        self.OnClose = self.MainFormClose
        #form 置中
        self.SetProps(Position='poDesktopCenter')
        #pnlTop
        self.pnlTop = CreateComponent('TPanel',self.FOwner)
        self.pnlTop.SetProps(Parent=self,Align='alTop',Height=60)
        #Label1
        self.Label1 = CreateComponent('TLabel',self.FOwner)
        self.Label1.SetProps(Parent=self.pnlTop, Caption="搜尋字串:")
        self.Label1.SetBounds(20, 18, 48, 24)
        #Label2
        self.Label2 = CreateComponent('TLabel',self.FOwner)
        self.Label2.SetProps(Parent=self.pnlTop, Caption="時間:")
        self.Label2.SetBounds(20, 40, 28, 24)

        #Label3
        self.Label3 = CreateComponent('TLabel',self.FOwner)
        self.Label3.SetProps(Parent=self.pnlTop, Caption="      ")
        self.Label3.SetBounds(60, 40, 48, 24)

        #edit1
        self.Edit1 = CreateComponent('TEdit',self.FOwner)
        self.Edit1.SetProps(Parent=self.pnlTop)
        self.Edit1.SetBounds(79, 15, 120, 24)
        
        #Button1
        self.Button1 = CreateComponent('TButton',self.FOwner)
        self.Button1.Parent = self.pnlTop
        self.Button1.Name='Button1'
        self.Button1.SetBounds(204,14,75,25)
        self.Button1.Caption = "Go"
        self.Button1.OnClick = self.Button2Click

        #button2
        self.Button2 = CreateComponent('TButton',self.FOwner)
        self.Button2.Parent = self.pnlTop
        self.Button2.Name='Button2'
        self.Button2.SetBounds(284,14,75,25)
        self.Button2.Caption = "Confirm1"
        self.Button2.OnClick = self.Button2Click

        #button3
        self.Button3 = CreateComponent('TButton',self.FOwner)
        self.Button3.Parent = self.pnlTop
        self.Button3.Name='Button3'
        self.Button3.SetBounds(364,14,75,25)
        self.Button3.Caption = "Confirm2"
        self.Button3.OnClick = self.Button2Click

        #PageControl
        self.pgControl =CreateComponent('TPageControl',self.FOwner)
        self.pgControl.Parent = self
        self.pgControl.Name='pgControl'
        self.pgControl.Align='alClient'
        #TabSheet1
        self.TabSheet1 =CreateComponent('TTabSheet',self.FOwner)
        self.TabSheet1.PageControl=self.pgControl
        self.TabSheet1.Parent = self.pgControl
        self.TabSheet1.Caption ='TabSheet1'

        #TabSheet2
        self.TabSheet2 =CreateComponent('TTabSheet',self.FOwner)
        self.TabSheet2.PageControl=self.pgControl
        self.TabSheet2.Parent = self.pgControl
        self.TabSheet2.Caption ='TabSheet2'
        #Memo1
        self.Memo1 =CreateComponent('TMemo',self.FOwner)
        self.Memo1.Parent = self.TabSheet1
        self.Memo1.Align ='alClient'
        self.Memo1.SCrollBars='ssBoth'
        self.Memo1.OnChange=self.mmoChanged
        #Timer
        self.Timer1 =CreateComponent('TTimer',self.FOwner)
        self.Timer1.OnTimer=self.Timer1Timer

    def mmoChanged(self, Sender):
        if self.Memo1.Lines.Count >=10:
            self.Memo1.Lines.Clear()
        
        # print(Sender.Name)
    def MainFormClose(self, Sender, Action):
        Action.Value = caFree

    def Timer1Timer(self, Sender):
        now=datetime.now()
        self.Label3.Caption =now.strftime("%H:%M:%S")
        pass
    #???  如何取得Sender 屬性
    def Button2Click(self, Sender):
        s=Sender.Name
        # print(s)
        if s=='Button2':
            m=mMessageDlg(self)
            if m.ShowDlg('訊息..','你確定要輸入資料嗎 ?'):
                self.Memo1.Lines.Add(f'點擊{s}->按下OK')
                self.Edit1.Text = ""
            else :
                self.Memo1.Lines.Add(f'點擊{s}->按下Cancel')
                self.Edit1.Text = ""
        if s=='Button1':
            self.Memo1.Lines.Add(f'點擊{s}->'+ self.Edit1.Text)
            self.Edit1.Text = ""
        if s=='Button3':
            t=(mbOK,mbCancel)
            if MessageDlg('請你輸入訊息內容...',mtConfirmation,t) ==mrOk:
                self.Memo1.Lines.Add(f'點擊{s}->按下OK')
            else:self.Memo1.Lines.Add(f'點擊{s}->沒有按下OK')



class mMessageDlg(Form):
    def __init__(self,Owner):
        # super(mMessageDlg, self).__init__(Owner)
        self.FOwner =Owner
        self.Caption = "MyDemo mMessageDlg"
        self.BorderStyle='bsDialog'
        self.SetBounds(10, 10, 420, 128)
        self.SetProps(Position='poDesktopCenter')
        #Laleb1
        self.Label1 = CreateComponent('TLabel',self.FOwner)
        self.Label1.Parent=self
        self.Label1.SetBounds(40, 22,60 , 24)

        #Button1
        self.btnOK = CreateComponent('TButton',self.FOwner)
        self.btnOK.Parent = self
        self.btnOK.SetBounds(156,56,75,25)
        self.btnOK.Caption = "OK"
        self.btnOK.OnClick = self.btnOKClick

        #Button1
        self.Button1 = CreateComponent('TButton',self.FOwner)
        self.Button1.Parent = self
        self.Button1.SetBounds(268,56,75,25)
        self.Button1.Caption = "Cancel"
        self.Button1.OnClick = self.Button1Click
        self.ModalResult=IDCANCEL

    def btnOKClick(self, Sender):
        self.ModalResult=IDOK 

    def Button1Click(self, Sender):
        self.ModalResult=IDCANCEL 
    
    def ShowDlg(self,iTitle,iText):
        self.Label1.Caption=iText
        self.Caption=iTitle
        
        return self.ShowModal()==IDOK

def main():
    Application.Initialize()
    Application.Title = "MyDelphiApp"
    f = MainForm(Application)
    f.Show()
    #不使用DOS Console
    # FreeConsole()
    Application.Run()

if __name__ =='__main__':
    main()

```

---

# 執行結果:

[https://www.youtube.com/watch?v=dH8frEgfmRQ](https://www.youtube.com/watch?v=dH8frEgfmRQ)


# 程式碼:
[source code](MyDelphiVcl/)
---

