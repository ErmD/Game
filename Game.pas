uses GraphWPF, WPFObjects, Timers;

var speed1 := 2; //Ball speed
var speed2 := 3; //Enemy speed

var PR := new TextWPF(122,60,40,'0', colors.red);
var PB := new TextWPF(665,60,40,'0', colors.blue);

var timeCount:= new TextWPF(370,160,20,'10', colors.Blue);
var timeRound:= new TextWPF(385,60,40,'30', colors.Black);

var ballRadius := 30;
var (x,y) := (ballRadius,150+ballRadius);
var Ball := new CircleWPF(ballRadius,150+ballRadius,ballRadius,gcolor.Fromrgb(255,0,0));
var (ml,mr,mt,mb) :=(false,false,false,false);

var ballRadius1 := 20;
var (x1,y1) := (810-ballRadius1,760-ballRadius1);
var Enemy := new CircleWPF(810-ballRadius1,760-ballRadius1,ballRadius1,gcolor.Fromrgb(0,0,255));
var (el,er,et,eb) :=(false,false,false,false);

//Настройки
procedure setup();
  begin
    Window.SetSize(800,750);
    Window.Caption := 'Игра из палок';
    Window.IsFixedSize := true;
    Window.CenterOnScreen();
  end;

//Клавиши
procedure keyDown(k: Key);
begin
  case k of
    Key.W: mt :=true;
    Key.S: mb :=true;
    Key.A: ml :=true;
    Key.D: mr :=true;
    
    Key.Up: et :=true;
    Key.Down: eb :=true;
    Key.Left: el :=true;
    Key.Right: er :=true;
  end;
end;

procedure keyUp(k: Key);
begin
  case k of
    Key.W: mt :=false;
    Key.S: mb :=false;
    Key.A: ml :=false;
    Key.D: mr :=false;
    
    Key.Up: et :=false;
    Key.Down: eb :=false;
    Key.Left: el :=false;
    Key.Right: er :=false;
  end;
end;

//Красный догнал
procedure TimerBall;
begin  
  var Going:= new TextWPF(260,420,40,'Красный догнал!', colors.white);
  Going.BackgroundColor := colors.Black;
  sleep(1000);
  Going.Destroy;
end;

//Синий убежал
procedure BlueWin;
begin  
  var BlWn:= new TextWPF(280,420,40,'Синий убежал!', colors.white);
  BlWn.BackgroundColor := colors.Black;
  sleep(1000);
  BlWn.Destroy;
end;

//Таймер на скорость
procedure timeTimer;
begin
  timeCount.Text := (strToInt(timeCount.Text) - 1).ToString;
end;

//Таймер раунда
procedure timeRoundProc;
begin
  timeRound.Text := (strToInt(timeRound.Text) - 1).ToString;
end;

//Таймер для очков красного
procedure tiPR;
begin
  PR.Text := (strToInt(PR.Text) + 1).ToString;
end;

//Таймер для очков красного
procedure tiPB;
begin
  PB.Text := (strToInt(PB.Text) + 1).ToString;
end;



//Основа
begin
  setup();
  
  //Верхнее окно
  FillRectangle(0,0,810,150,color.FromRgb(200,200,200));
  FillRectangle(0,150,810,1,color.FromRgb(0,0,0));
  FillRectangle(270,0,1,150,color.FromRgb(0,0,0));
  FillRectangle(540,0,1,150,color.FromRgb(0,0,0));
  new TextWPF(320,10,25,'Время раунда', colors.black);
  new TextWPF(50,10,25,'Очки красного', colors.red);
  new TextWPF(600,10,25,'Очки синего', colors.blue);

  OnKeyDown := KeyDown;
  OnKeyUp := KeyUp;
  
  Var t := new Timer(10,TimerBall);
  var time := New Timer (1000,timeTimer);
  var TPR := new Timer (2000,tiPR);
  var TPB := new Timer (2000,tiPB);
  var blwn := new Timer (1000,BlueWin);
  var timeR := New Timer (1000,timeRoundProc);
  timeR.Start;
  time.Start;
  
  var gameState := true;
  while gameState do
    begin
      if (timeCount.Text = '0') then 
        begin 
          speed1 := 3;
          timeCount.Text := 'Скорость увеличена'
        end;
        
      //Если красный догнал
      if ObjectsIntersect(Ball,Enemy) then 
        begin
          TPR.Start;
          speed1 := 2;
          time.Stop;
          timeR.Stop;
          t.Start;
          Sleep(3000);
          t.Stop;
          TPR.Stop;
          
          Ball.Left := 0;
          Ball.Top := 150;
          (x,y) := (ballRadius,150+ballRadius);
          
          Enemy.Left := 810-2*ballRadius1;
          Enemy.Top := 760-2*ballRadius1;
          (x1,y1) := (810-ballRadius1,760-ballRadius1);
          
          timeCount.Text := '10';
          timeRound.Text := '30';
          timeR.Start;
          time.Start;        
        end;
        
        //Если синий убежал
        if timeRound.Text = '0' then 
        begin
          TPB.Start;
          speed1 := 2;
          time.Stop;
          timeR.Stop;
          blwn.Start;
          Sleep(3000);
          blwn.Stop;
          TPB.Stop;

          Ball.Left := 0;
          Ball.Top := 150;
          (x,y) := (ballRadius,150+ballRadius);
          
          Enemy.Left := 810-2*ballRadius1;
          Enemy.Top := 760-2*ballRadius1;
          (x1,y1) := (810-ballRadius1,760-ballRadius1);
          
          timeCount.Text := '10';
          timeRound.Text := '30';
          timeR.Start;
          time.Start;        
        end;
      
      //Передвижение Красного
      if ((ml)and(x>ballRadius)) then 
        begin
          Ball.Left -= Speed1;
          x-=speed1;
        end;
      if ((mr)and(x<810-ballRadius)) then 
        begin
          Ball.Left += speed1;
          x+=speed1;
        end;
      if ((mt)and(y>150+ballRadius)) then
        begin
          Ball.Top -= speed1;
          y-=speed1;
        end;
      if ((mb)and(y<759-ballRadius)) then 
        begin
          Ball.Top += speed1;
          y+=speed1;
        end;
          
        {----------------------------------------}
        
      //Передвижение Синего
      if ((el)and(x1>ballRadius1)) then 
        begin
          Enemy.Left -= speed2;
          x1-=speed2;
        end;
      if ((er)and(x1<810-ballRadius1)) then 
        begin
          Enemy.Left += speed2;
          x1+=speed2;
        end;
      if ((et)and(y1>150+ballRadius1)) then
        begin
          Enemy.Top -= speed2;
          y1-=speed2;
        end;
      if ((eb)and(y1<760-ballRadius1)) then 
        begin
          Enemy.Top += speed2;
          y1+=speed2;
        end;
    sleep(5);
    end;
  
end.