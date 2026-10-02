Add-Type -AssemblyName System.Drawing
$CD=[char]0xCD; $E1=[char]0xE1; $E3=[char]0xE3; $C7=[char]0xE7; $E9=[char]0xE9; $F3=[char]0xF3
$bmp=New-Object Drawing.Bitmap(1920,1080)
$g=[Drawing.Graphics]::FromImage($bmp); $g.SmoothingMode="AntiAlias"; $g.TextRenderingHint="AntiAlias"
$g.Clear([Drawing.Color]::FromArgb(239,234,216))
$green=New-Object Drawing.SolidBrush([Drawing.Color]::FromArgb(108,122,80))
$path=New-Object Drawing.Drawing2D.GraphicsPath
$path.StartFigure()
$path.AddLine(0,0,1170,0)
$path.AddBezier((New-Object Drawing.PointF(1170,0)),(New-Object Drawing.PointF(1120,520)),(New-Object Drawing.PointF(880,880)),(New-Object Drawing.PointF(430,1080)))
$path.AddLine(430,1080,0,1080)
$path.CloseFigure()
$g.FillPath($green,$path)
$green.Dispose()
$pale=New-Object Drawing.SolidBrush([Drawing.Color]::FromArgb(220,226,130))
$fTitle=New-Object Drawing.Font("Times New Roman",68)
$fNum=New-Object Drawing.Font("Arial",36)
$fSub=New-Object Drawing.Font("Times New Roman",28)
$g.DrawString($CD+"NDICE",$fTitle,$pale,130,70)
$y=230
function Num($t){ $g.DrawString($t,$fNum,$pale,130,$y); $script:y=$y+58 }
function Sub($t){ $g.DrawString($t,$fSub,$pale,200,$y); $script:y=$y+44 }
Num ("1. Enquadramento Territorial")
$y=$y+18
Num ("2. Caracteriza"+$C7+$E3+"o do Territ"+$F3+"rio")
Sub ("Cultura e an"+$E1+"lise pr"+$E9+"-existente")
Sub "Fauna e flora"
Sub "Geologia"
Sub ("Paleta crom"+$E1+"tica")
Sub "Topografia"
Sub ("Sistema de "+$E1+"gua")
$y=$y+18
Num ("3. Caracteriza"+$C7+$E3+"o Clim"+$E1+"tica")
Sub ("Radia"+$C7+$E3+"o solar")
Sub "Fluxos de ar"
Sub "Temperatura"
Sub "Nebulosidade"
Sub "Humidade"
Sub ("Precipita"+$C7+$E3+"o")
$y=$y+18
Num ("4. An"+$E1+"lise SWOT")
$pale.Dispose()
$out=Join-Path $PSScriptRoot "indice-mockup.png"
$bmp.Save($out,[Drawing.Imaging.ImageFormat]::Png)
$g.Dispose(); $bmp.Dispose()
Write-Output "saved ok"