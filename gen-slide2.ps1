Add-Type -AssemblyName System.Drawing
$E2=[char]0xE2; $E3=[char]0xE3; $C7=[char]0xE7; $E9=[char]0xE9; $ED=[char]0xED; $F3=[char]0xF3
$R=6378137; $RAD=[Math]::PI/180
$mmX0=$R*-7.95*$RAD; $mmX1=$R*-6.60*$RAD
$mmY0=$R*[Math]::Log([Math]::Tan([Math]::PI/4+(40.75*$RAD)/2)); $mmY1=$R*[Math]::Log([Math]::Tan([Math]::PI/4+(41.58*$RAD)/2))
$BOUND=@(@(-7.3653,41.4404),@(-7.3513,41.3668),@(-7.2857,41.3323),@(-7.2246,41.2368),@(-7.1004,41.2443),@(-7.0551,41.3040),@(-6.8271,41.2052),@(-6.7395,41.2408),@(-6.6898,41.2052),@(-6.8078,41.0487),@(-6.9299,41.0293),@(-7.0551,40.9675),@(-7.1520,40.9292),@(-7.1943,41.0286),@(-7.3628,41.0109),@(-7.3361,40.9452),@(-7.4157,40.9099),@(-7.4542,40.8126),@(-7.5280,40.8688),@(-7.5908,40.8409),@(-7.6896,40.8634),@(-7.7012,40.9331),@(-7.9157,41.0200),@(-7.8596,41.1129),@(-7.8968,41.1657),@(-7.8841,41.2352),@(-7.9077,41.3026),@(-7.7887,41.4114),@(-7.6058,41.4025),@(-7.4934,41.4506),@(-7.4223,41.5160))
$DOURO=@(@(41.05,-6.93),@(41.08,-7.05),@(41.13,-7.11),@(41.16,-7.25),@(41.18,-7.40),@(41.19,-7.54),@(41.16,-7.78),@(41.16,-7.95))
$bmp=New-Object Drawing.Bitmap(1920,1080)
$g=[Drawing.Graphics]::FromImage($bmp); $g.SmoothingMode="AntiAlias"; $g.TextRenderingHint="AntiAlias"
$g.Clear([Drawing.Color]::FromArgb(241,235,215))
$olive=[Drawing.Color]::FromArgb(110,110,69)
$brOlive=New-Object Drawing.SolidBrush($olive)
$brB=[Drawing.Brushes]::Black; $brG=[Drawing.Brushes]::DimGray
$fHead=New-Object Drawing.Font("Arial",26); $fT=New-Object Drawing.Font("Arial",46); $fST=New-Object Drawing.Font("Arial",32)
$fCap=New-Object Drawing.Font("Arial",17); $fB=New-Object Drawing.Font("Arial",19); $fSrc=New-Object Drawing.Font("Arial",13)
$g.DrawString("Macro-An"+$E2+"lise",$fHead,$brOlive,1620,48)
$g.DrawString("2. Caracteriza"+$C7+$E3+"o do Territ"+$F3+"rio",$fT,$brOlive,80,86)
$g.DrawString("Topografia",$fST,$brOlive,140,152)
# panels
$rx1=80; $ry1=270; $rw1=880; $rh1=616
$rx2=1020; $ry2=270; $rw2=760; $rh2=532
$img1=[Drawing.Image]::FromFile((Join-Path $PSScriptRoot "panel-basin.png"))
$img2=[Drawing.Image]::FromFile((Join-Path $PSScriptRoot "panel-elev.png"))
$g.DrawImage($img1,$rx1,$ry1,$rw1,$rh1)
$g.DrawImage($img2,$rx2,$ry2,$rw2,$rh2)
$img1.Dispose(); $img2.Dispose()
# overlay helper inline per panel
foreach($pk in @(1,2)){
  if($pk -eq 1){ $ox=$rx1; $oy=$ry1; $ow=$rw1; $oh=$rh1 } else { $ox=$rx2; $oy=$ry2; $ow=$rw2; $oh=$rh2 }
  $bp=New-Object Drawing.Drawing2D.GraphicsPath
  $fst=$true
  foreach($q in $BOUND){
    $mx=$R*$q[0]*$RAD
    $my=$R*[Math]::Log([Math]::Tan([Math]::PI/4+($q[1]*$RAD)/2))
    $qx=$ox+($mx-$mmX0)/($mmX1-$mmX0)*$ow
    $qy=$oy+($mmY1-$my)/($mmY1-$mmY0)*$oh
    if($fst){ $bp.StartFigure(); $fst=$false } else { $bp.AddLine($lx,$ly,$qx,$qy) }
    $lx=$qx; $ly=$qy
  }
  $bp.CloseFigure()
  $g.DrawPath((New-Object Drawing.Pen([Drawing.Color]::Black,3)),$bp)
  $penR2=New-Object Drawing.Pen([Drawing.Color]::FromArgb(29,78,158),4)
  for($i=0;$i -lt $DOURO.Count-1;$i++){
    $m1x=$R*$DOURO[$i][1]*$RAD
    $m1y=$R*[Math]::Log([Math]::Tan([Math]::PI/4+($DOURO[$i][0]*$RAD)/2))
    $m2x=$R*$DOURO[$i+1][1]*$RAD
    $m2y=$R*[Math]::Log([Math]::Tan([Math]::PI/4+($DOURO[$i+1][0]*$RAD)/2))
    $p1x=$ox+($m1x-$mmX0)/($mmX1-$mmX0)*$ow
    $p1y=$oy+($mmY1-$m1y)/($mmY1-$mmY0)*$oh
    $p2x=$ox+($m2x-$mmX0)/($mmX1-$mmX0)*$ow
    $p2y=$oy+($mmY1-$m2y)/($mmY1-$mmY0)*$oh
    $g.DrawLine($penR2,$p1x,$p1y,$p2x,$p2y)
  }
  $penR2.Dispose()
}
# labels on sat panel
function Lab($lon,$lat,$txt,$sz,$pan){
  if($pan -eq 1){ $ox=$rx1; $oy=$ry1; $ow=$rw1; $oh=$rh1 } else { $ox=$rx2; $oy=$ry2; $ow=$rw2; $oh=$rh2 }
  $mx=$R*$lon*$RAD
  $my=$R*[Math]::Log([Math]::Tan([Math]::PI/4+($lat*$RAD)/2))
  $qx=$ox+($mx-$mmX0)/($mmX1-$mmX0)*$ow
  $qy=$oy+($mmY1-$my)/($mmY1-$mmY0)*$oh
  $fn=New-Object Drawing.Font("Arial",$sz)
  $g.DrawString($txt,$fn,[Drawing.Brushes]::White,$qx+10,$qy-10)
  $fn.Dispose()
}
Lab -7.44 41.31 "Vila Real" 15 1
Lab -7.78 41.13 ("R"+$E9+"gua") 13 1
Lab -7.11 41.04 ("Foz C"+$F4+"a") 13 1
Lab -7.80 41.22 ("MAR"+$E3+"O 1416 m") 14 1
Lab -7.44 41.31 "Vila Real" 13 2
Lab -7.11 41.04 ("Foz C"+$F4+"a") 11 2
# elevation scale next to panel 2
$steps=@(@(1500,"C94F4F"),@(1300,"D06A5A"),@(1100,"D68465"),@(950,"DCA070"),@(800,"E2B97E"),@(650,"E8D189"),@(550,"EEE699"),@(450,"E8EAA0"),@(350,"CFE0A0"),@(250,"AED6A0"),@(150,"93C9A0"),@(80,"8FC0A5"),@(40,"A5C9B0"),@(0,"B9D4E4"))
$sy=$ry2
foreach($st in $steps){
  $col=[Drawing.ColorTranslator]::FromHtml("#"+$st[1])
  $br=New-Object Drawing.SolidBrush($col)
  $g.FillRectangle($br,1782,$sy,52,38)
  $g.DrawString($st[0].ToString()+" m",$fCap,$brB,1840,$sy+8)
  $br.Dispose()
  $sy=$sy+38
}
# captions + numbers
$g.DrawString("Bacia NUTS III Douro (PT11D) - imagem de sat"+$E9+"lite (Esri)",$fCap,$brG,$rx1,($ry1+$rh1+8))
$g.DrawString("Mar"+$E3+"o 1 416 m  -  Vila Real ~442 m  -  Douro 40-80 m",$fCap,$brB,$rx1,($ry1+$rh1+34))
$g.DrawString("Relevo com hipsometria 0-1500 m (SRTM)",$fCap,$brG,$rx2,($ry2+$rh2+8))
# bullets right column
$bt="- Relevo: vale encaixado E-W, 1 416 m no Mar"+$E3+"o, 40-80 m no Douro; Vila Real a meia-encosta (~442 m).`n- Solo: xisto em socalcos, granito a oeste, aluvi"+$E3+"o com cheia e geada no fundo do vale.`n- Projeto: massa de xisto + ventila"+$C7+$E3+"o noturna; sombra caducif"+$F4+"lia e corti"+$C7+"a; afastar pinho/eucalipto."
$rect=New-Object Drawing.RectangleF($rx2,($ry2+$rh2+56),$rw2,210)
$g.DrawString($bt,$fB,$brB,$rect)
$g.DrawString("Contorno: GISCO NUTS 2024 PT11D. Bases: Esri World Imagery / Topo, SRTM. Rocha: sintese LNEG.",$fSrc,[Drawing.Brushes]::Gray,80,1022)
$out=Join-Path $PSScriptRoot "slide2-topografia-mockup.png"
$bmp.Save($out,[Drawing.Imaging.ImageFormat]::Png)
$g.Dispose(); $bmp.Dispose()
Write-Output "saved ok"