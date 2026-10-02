Add-Type -AssemblyName System.Drawing
$E9=[char]0xE9; $E3=[char]0xE3; $C7=[char]0xE7; $F4=[char]0xF4; $ED=[char]0xED; $E1=[char]0xE1; $FA=[char]0xFA
$W=1500; $H=1000
$X0=80; $X1=1420; $DMAX=95.0
$YBASE=780; $YTOP=230; $EMAX=1500.0
function MX($d){ return $X0+($d/$DMAX)*($X1-$X0) }
function MY($e){ return $YBASE-($e/$EMAX)*($YBASE-$YTOP) }
$bmp=New-Object Drawing.Bitmap($W,$H)
$g=[Drawing.Graphics]::FromImage($bmp); $g.SmoothingMode="AntiAlias"; $g.TextRenderingHint="AntiAlias"
$g.Clear([Drawing.Color]::White)
$penB=New-Object Drawing.Pen([Drawing.Color]::Black,6); $g.DrawRectangle($penB,3,3,($W-6),($H-6)); $penB.Dispose()
$fT=New-Object Drawing.Font("Arial",28); $fM=New-Object Drawing.Font("Arial",15); $fS=New-Object Drawing.Font("Arial",13); $fN=New-Object Drawing.Font("Arial",14)
$brB=[Drawing.Brushes]::Black; $brG=[Drawing.Brushes]::DimGray; $brBl=[Drawing.Brushes]::DarkBlue
$g.DrawString("3. Caracteriza"+$C7+$E3+"o Clim"+$E1+"tica - corte W-E esquem"+$E1+"tico",$fT,$brB,60,40)
$g.DrawString("Inverno frio e h"+$FA+"mido (E) / Ver"+$E3+"o quente e seco - Mar"+$E3+"o fecha a oeste",$fM,$brG,60,85)
# terrain profile (km, m)
$prof=@(@(0,650),@(10,1416),@(20,800),@(30,500),@(38,442),@(46,250),@(52,60),@(60,350),@(68,550),@(76,450),@(84,150),@(90,120),@(95,380))
$path=New-Object Drawing.Drawing2D.GraphicsPath
$first=$true
foreach($q in $prof){ $cx=MX $q[0]; $cy=MY $q[1]
  if($first){ $path.StartFigure(); $first=$false } else { $path.AddLine($px,$py,$cx,$cy) }
  $px=$cx; $py=$cy }
$path.AddLine($px,$py,$px,$YBASE); $path.AddLine($px,$YBASE,$X0,$YBASE); $path.CloseFigure()
$fill=New-Object Drawing.SolidBrush([Drawing.Color]::FromArgb(216,201,168))
$g.FillPath($fill,$path)
$g.DrawPath((New-Object Drawing.Pen([Drawing.Color]::Black,3)),$path)
$fill.Dispose()
# Douro ticks
$penR=New-Object Drawing.Pen([Drawing.Color]::FromArgb(29,78,158),5)
foreach($dd in @(52,90)){ $cx=MX $dd; $cy=MY 60; $g.DrawLine($penR,$cx-22,$cy,$cx+22,$cy) }
$penR.Dispose()
$g.DrawString("Douro",$fS,$brBl,(MX 52)-92,(MY 60)-8)
# place labels
$g.DrawString("Mar"+$E3+"o 1416 m",$fM,$brB,(MX 10)-70,(MY 1416)-34)
# vila real label drawn after house (on top)
$g.DrawString("R"+$E9+"gua",$fM,$brB,(MX 52)-40,(MY 60)+26)
$g.DrawString("Foz C"+$F4+"a 120 m",$fM,$brB,(MX 90)-70,(MY 120)-32)
# winter: E cold arrow from right
$penW=New-Object Drawing.Pen([Drawing.Color]::SteelBlue,4)
$ax1=MX 95; $ay1=330; $ax0=$ax1-170
$g.DrawLine($penW,$ax1,$ay1,$ax0,$ay1)
$tri=New-Object Drawing.Drawing2D.GraphicsPath
$tri.AddPolygon(@((New-Object Drawing.PointF($ax0,($ay1-9))),(New-Object Drawing.PointF($ax0,($ay1+9))),(New-Object Drawing.PointF(($ax0-16),$ay1))))
$g.FillPath([Drawing.Brushes]::SteelBlue,$tri)
$g.DrawString("fluxos E frios",$fS,[Drawing.Brushes]::SteelBlue,$ax0-40,$ay1-34)
$penW.Dispose()
# cold pool ellipse in valley
$brPool=New-Object Drawing.SolidBrush([Drawing.Color]::FromArgb(90,170,210,235))
$ex=MX 52; $ey=MY 60
$g.FillEllipse($brPool,$ex-120,$ey-46,240,44)
$g.DrawString("ar frio acumula no vale",$fS,[Drawing.Brushes]::SteelBlue,$ex-118,$ey-44)
$brPool.Dispose()
$g.DrawString("INVERNO: isolamento + ganho solar passivo",$fS,$brB,100,640)
# summer: high sun + shading + W breeze
$brSun=New-Object Drawing.SolidBrush([Drawing.Color]::FromArgb(255,200,40))
$g.FillEllipse($brSun,700,150,64,64)
$penSun=New-Object Drawing.Pen([Drawing.Color]::FromArgb(255,200,40),3)
for($a=0;$a -lt 8;$a++){ $t=$a*0.7853982
  $g.DrawLine($penSun,732+[Math]::Cos($t)*40,182+[Math]::Sin($t)*40,732+[Math]::Cos($t)*54,182+[Math]::Sin($t)*54) }
$penSun.Dispose(); $brSun.Dispose()
$g.DrawString("VER"+$E3+"O: sol alto a sombrear + in"+$E9+"rcia t"+$E9+"rmica",$fS,$brB,790,172)
# W breeze arrow to house
$penB2=New-Object Drawing.Pen([Drawing.Color]::FromArgb(29,78,158),4)
$bx1=MX 20; $by1=420; $bx0=$bx1-150
$g.DrawLine($penB2,$bx0,$by1,$bx1,$by1)
$tri2=New-Object Drawing.Drawing2D.GraphicsPath
$tri2.AddPolygon(@((New-Object Drawing.PointF($bx1,($by1-9))),(New-Object Drawing.PointF($bx1,($by1+9))),(New-Object Drawing.PointF(($bx1+16),$by1))))
$brB2=New-Object Drawing.SolidBrush([Drawing.Color]::FromArgb(29,78,158))
$g.FillPath($brB2,$tri2)
$g.DrawString("brisas W para ventila"+$C7+$E3+"o cruzada noturna",$fS,$brB2,$bx0-30,$by1+12)
$penB2.Dispose()
# small house pictogram at Vila Real shelf
$hx=MX 38; $hy=MY 442
$g.FillRectangle([Drawing.Brushes]::White,$hx-46,$hy-64,92,64)
$g.DrawRectangle([Drawing.Pens]::Black,$hx-46,$hy-64,92,64)
$roof=New-Object Drawing.Drawing2D.GraphicsPath
$roof.AddPolygon(@((New-Object Drawing.PointF(($hx-54),($hy-64))),(New-Object Drawing.PointF(($hx+54),($hy-64))),(New-Object Drawing.PointF($hx,($hy-104)))))
$g.FillPath([Drawing.Brushes]::Black,$roof)
$penA=New-Object Drawing.Pen([Drawing.Color]::FromArgb(29,78,158),3)
$g.DrawLine($penA,$hx-70,$hy-32,$hx+70,$hy-32)
$penA.Dispose()
# deciduous tree
$g.DrawLine([Drawing.Pens]::Black,$hx+78,$hy,$hx+78,$hy-44)
$g.FillEllipse([Drawing.Brushes]::Green,$hx+52,$hy-84,52,44)
$g.DrawString("sombra caducif"+$F4+"lia",$fS,$brG,$hx+44,$hy-104)
$g.DrawString("Vila Real 442 m",$fM,$brB,$hx-220,$hy-72)
# source
$g.DrawString("Corte esquem"+$E1+"tico sem escala exata. Relevo: SRTM/Esri. Clima: IPMA 1991-2020.",(New-Object Drawing.Font("Arial",12)),[Drawing.Brushes]::Gray,60,940)
$out=Join-Path $PSScriptRoot "douro-climate-section.png"
$bmp.Save($out,[Drawing.Imaging.ImageFormat]::Png)
$g.Dispose(); $bmp.Dispose()
Write-Output "saved ok"