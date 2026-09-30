Add-Type -AssemblyName System.Drawing
$R=6378137; $RAD=[Math]::PI/180
$LON0=-8.0; $LAT0=40.70; $LON1=-6.55; $LAT1=41.62
$X0=$R*$LON0*$RAD; $X1=$R*$LON1*$RAD
$Y0=$R*[Math]::Log([Math]::Tan([Math]::PI/4+($LAT0*$RAD)/2)); $Y1=$R*[Math]::Log([Math]::Tan([Math]::PI/4+($LAT1*$RAD)/2))
# map panel geometry
$OX=40; $OY=170; $W=940; $H=660
function PX($lon,$lat){
  $px=$R*$lon*$RAD
  $py=$R*[Math]::Log([Math]::Tan([Math]::PI/4+($lat*$RAD)/2))
  $rx=$OX+($px-$X0)/($X1-$X0)*$W
  $ry=$OY+($Y1-$py)/($Y1-$Y0)*$H
  $rx
  $ry
}
$BOUND=@(@(-7.3653,41.4404),@(-7.3513,41.3668),@(-7.2857,41.3323),@(-7.2246,41.2368),@(-7.1004,41.2443),@(-7.0551,41.3040),@(-6.8271,41.2052),@(-6.7395,41.2408),@(-6.6898,41.2052),@(-6.8078,41.0487),@(-6.9299,41.0293),@(-7.0551,40.9675),@(-7.1520,40.9292),@(-7.1943,41.0286),@(-7.3628,41.0109),@(-7.3361,40.9452),@(-7.4157,40.9099),@(-7.4542,40.8126),@(-7.5280,40.8688),@(-7.5908,40.8409),@(-7.6896,40.8634),@(-7.7012,40.9331),@(-7.9157,41.0200),@(-7.8596,41.1129),@(-7.8968,41.1657),@(-7.8841,41.2352),@(-7.9077,41.3026),@(-7.7887,41.4114),@(-7.6058,41.4025),@(-7.4934,41.4506),@(-7.4223,41.5160))
$DOURO=@(@(41.05,-6.93),@(41.08,-7.05),@(41.13,-7.11),@(41.16,-7.25),@(41.18,-7.40),@(41.19,-7.54),@(41.16,-7.78),@(41.16,-7.95))
$TRIBS=@(
 @{s=@(@(40.78,-7.05),@(40.92,-7.08),@(41.13,-7.11)); d=@(@(40.68,-7.02),@(40.78,-7.05))},
 @{s=@(@(41.32,-7.02),@(41.18,-7.11),@(41.125,-7.10)); d=@(@(41.50,-6.92),@(41.32,-7.02))},
 @{s=@(@(41.38,-7.40),@(41.181,-7.42)); d=@(@(41.58,-7.34),@(41.38,-7.40))},
 @{s=@(@(41.30,-7.77),@(41.16,-7.78)); d=@(@(41.46,-7.75),@(41.30,-7.77))},
 @{s=@(@(41.00,-7.57),@(41.189,-7.55)); d=@(@(40.88,-7.60),@(41.00,-7.57))},
 @{s=@(@(41.05,-7.77),@(41.163,-7.75)); d=@(@(40.94,-7.80),@(41.05,-7.77))},
 @{s=@(@(41.25,-7.53),@(41.19,-7.54)); d=@(@(41.33,-7.50),@(41.25,-7.53))},
 @{s=@(@(41.20,-7.38),@(41.18,-7.40)); d=@(@(41.28,-7.35),@(41.20,-7.38))}
)
$DAMS=@(@(-7.113,41.134,"Pocinho"),@(-7.375,41.157,"Valeira"),@(-7.77,41.163,"Regua"),@(-7.42,41.208,"Foz Tua"))
$BANDS=@(@(-8.0,-7.85,"7FB8D9","1400+"),@(-7.85,-7.70,"93C4DE","1201-1400"),@(-7.70,-7.50,"A9CFE3","1001-1200"),@(-7.50,-7.30,"C2DCEA","801-1000"),@(-7.30,-7.05,"D8E7EF","601-800"),@(-7.05,-6.55,"E8E4D8","400-600"))
$bmp=New-Object Drawing.Bitmap(1500,1050)
$g=[Drawing.Graphics]::FromImage($bmp); $g.SmoothingMode="AntiAlias"; $g.TextRenderingHint="AntiAlias"
$g.Clear([Drawing.Color]::White)
$penB=New-Object Drawing.Pen([Drawing.Color]::Black,6); $g.DrawRectangle($penB,3,3,1494,1044); $penB.Dispose()
$fTitle=New-Object Drawing.Font("Arial",30); $fSub=New-Object Drawing.Font("Arial",20); $fLab=New-Object Drawing.Font("Arial",15); $fSmall=New-Object Drawing.Font("Arial",13); $fLeg=New-Object Drawing.Font("Arial",15); $fNote=New-Object Drawing.Font("Arial",14)
$brB=[Drawing.Brushes]::Black; $brG=[Drawing.Brushes]::DimGray
$g.DrawString("Mapping of all water conveyance systems across",(New-Object Drawing.Font("Arial",30)),$brB,40,35)
$g.DrawString("the territory - Douro NUTS III (PT11D)",(New-Object Drawing.Font("Arial",30)),$brB,40,75)
# boundary path in panel coords
function PathOf($pts){ $p=New-Object Drawing.Drawing2D.GraphicsPath
  $first=$true; foreach($q in $pts){ $c=PX $q[0] $q[1]
    if($first){ $p.StartFigure(); $first=$false } else { $p.AddLine($pp[0],$pp[1],$c[0],$c[1]) } $pp=$c }
  $p.CloseFigure(); return $p }
$bpath=PathOf $BOUND
# precip bands clipped
$g.SetClip($bpath)
foreach($b in $BANDS){ $bx0=(PX $b[0] 41)[0]; $bx1=(PX $b[1] 41)[0]
  $col=[Drawing.ColorTranslator]::FromHtml("#"+$b[2]); $br=New-Object Drawing.SolidBrush($col)
  $g.FillRectangle($br,$bx0,$OY,($bx1-$bx0),$H); $br.Dispose() }
$g.ResetClip()
$g.DrawPath((New-Object Drawing.Pen([Drawing.Color]::Black,3.5)),$bpath)
$g.SetClip($bpath)
# rivers
function DrawLine($pts,$lw,$dash){ $pen=New-Object Drawing.Pen([Drawing.Color]::FromArgb(29,78,158),$lw)
  if($dash){ $pen.DashStyle=[Drawing.Drawing2D.DashStyle]::Dash }
  for($i=0;$i -lt $pts.Count-1;$i++){ $a=PX $pts[$i][1] $pts[$i][0]; $c=PX $pts[$i+1][1] $pts[$i+1][0]
    $g.DrawLine($pen,$a[0],$a[1],$c[0],$c[1]) } $pen.Dispose() }
DrawLine $DOURO 5 $false
foreach($t in $TRIBS){ DrawLine $t.s 2.5 $false; DrawLine $t.d 2 $true }
$g.ResetClip()
# dams + vila real
foreach($d in $DAMS){ $c=PX $d[0] $d[1]; $g.FillRectangle([Drawing.Brushes]::Black,$c[0]-7,$c[1]-5,14,10)
  if($d[2] -eq "Foz Tua"){ $g.DrawString($d[2],$fSmall,$brG,$c[0]-72,$c[1]-26) } else { $g.DrawString($d[2],$fSmall,$brG,$c[0]-30,$c[1]+8) } }
$c=PX -7.44 41.31; $g.FillEllipse([Drawing.Brushes]::Black,$c[0]-5,$c[1]-5,10,10)
$g.DrawString("Vila Real",$fLab,$brG,$c[0]+10,$c[1]-12)
# legend
$g.DrawString("Annual",$fLeg,$brB,1030,220); $g.DrawString("Precipitation (mm)",$fLeg,$brB,1030,245)
$y=290
foreach($b in $BANDS){ $col=[Drawing.ColorTranslator]::FromHtml("#"+$b[2]); $br=New-Object Drawing.SolidBrush($col)
  $g.FillRectangle($br,1030,$y,52,20); $g.DrawRectangle([Drawing.Pens]::Gray,1030,$y,52,20); $br.Dispose()
  $g.DrawString($b[3],$fLeg,$brB,1092,$y-3)
  $y+=34; if($b[3] -eq "801-1000"){ $y+=6 } }
$g.DrawString("perennial river",$fSmall,$brG,1080,560); $p1=New-Object Drawing.Pen([Drawing.Color]::FromArgb(29,78,158),4); $g.DrawLine($p1,1030,568,1072,568); $p1.Dispose()
$g.DrawString("seasonal stream",$fSmall,$brG,1080,590); $p2=New-Object Drawing.Pen([Drawing.Color]::FromArgb(29,78,158),3); $p2.DashStyle=[Drawing.Drawing2D.DashStyle]::Dash; $g.DrawLine($p2,1030,598,1072,598); $p2.Dispose()
$g.FillRectangle([Drawing.Brushes]::Black,1030,618,12,9); $g.DrawString("large dam",$fSmall,$brG,1080,614)
# notes
$g.DrawString("West-east gradient: Marao 1,416 m / 1400 mm+ W, Douro Superior 400-600 mm E. Pocinho / Valeira / Regua + Foz Tua regulate the stem.",$fNote,$brB,40,880)
$g.DrawString("Boundary: GISCO NUTS 2024 PT11D. Rivers/dams schematic (SNIAmb/APA, EDP). Rainfall schematic (IPMA 1991-2020).",$fSmall,[Drawing.Brushes]::Gray,40,910)
$out=Join-Path $PSScriptRoot "douro-water-board.png"
$bmp.Save($out,[Drawing.Imaging.ImageFormat]::Png)
$g.Dispose(); $bmp.Dispose()
Write-Output "saved $out"
