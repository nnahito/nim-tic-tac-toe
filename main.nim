import nigui
import nigui/msgbox

app.init()
var window = newWindow()
window.width = 600 + 17
window.height = 600 + 40

# 定数
const areaFree = 0                  # まだ、◯も☓も決まっていない場所
const areaArc = 1                   # ◯
const areaCross = 2                 # ☓

# drawableな要素
var control1 = newControl()
window.add(control1)

# drawableな要素をWindowいっぱいに表示
control1.widthMode = WidthMode_Fill
control1.heightMode = HeightMode_Fill

# ◯☓のエリア定義
var area = @[
    @[areaFree, areaFree, areaFree],
    @[areaFree, areaFree, areaFree],
    @[areaFree, areaFree, areaFree]
]

# ◯☓入力のターン
var tarn = 0


# ================================================================
# paintイベント
# ================================================================
control1.onDraw = proc (event: DrawEvent) =
  let canvas = event.control.canvas

  # 背景
  canvas.areaColor = rgb(240, 240, 240)
  canvas.fill()

  # 線の色
  canvas.lineColor = rgb(5, 5, 5)
  # 横線
  canvas.drawLine(0, 200, 600, 200)
  canvas.drawLine(0, 400, 600, 400)
  # 縦線
  canvas.drawLine(200, 0, 200, 600)
  canvas.drawLine(400, 0, 400, 600)

  # ◯☓を描画していく
  var y = 0
  for areaY in area:
    var x = 0
    for areaX in areaY:
      if areaX == areaArc:
        # ◯が占領しているとき
        canvas.drawArcOutline(100 * (x + 1) + 100 * x, 100 * (y + 1) + 100 * y, 80, 0, 360)
      elif areaX == areaCross:
        # ☓が占領しているとき
        canvas.drawLine(10 + 200 * x, 10 + 200 * y, 180 + 200 * x, 180 + 200 * y)
        canvas.drawLine(180 + 200 * x, 10 + 200 * y, 10 + 200 * x, 180 + 200 * y)

      x += 1
    y += 1



# ================================================================
# clickイベント
# ================================================================
control1.onMouseButtonDown = proc (event: MouseEvent) =
  # クリックされた座標を取得
  let x = event.x
  let y = event.y

  # クリックされた座標がどのエリアかを判定
  let posX = int(x / 200)
  let posY = int(y / 200)

  # 対象箇所のエリアを上書き。ただし、すでに占領されていれば上書きはできない
  if area[posY][posX] == areaFree:
    if tarn == 0:
      # ◯で占領してターンを☓に切り替える
      area[posY][posX] = areaArc
      tarn = 1
    else:
      # ☓で占領してターンを◯に切り替える
      area[posY][posX] = areaCross
      tarn = 0

  # ゲーム板の再描画
  forceRedraw(control1)

  # 勝利判定（愚直に行く。なんかいい方法あったら教えてくだちゃい）
  let line1 = area[0][0] == area[0][1] and area[0][1] == area[0][2] and area[0][0] != areaFree and area[0][1] != areaFree and area[0][2] != areaFree
  let line2 = area[1][0] == area[1][1] and area[1][1] == area[1][2] and area[1][0] != areaFree and area[1][1] != areaFree and area[1][2] != areaFree
  let line3 = area[2][0] == area[2][1] and area[2][1] == area[2][2] and area[2][0] != areaFree and area[2][1] != areaFree and area[2][2] != areaFree
  let line4 = area[0][0] == area[1][0] and area[1][0] == area[2][0] and area[0][0] != areaFree and area[1][0] != areaFree and area[2][0] != areaFree
  let line5 = area[0][1] == area[1][1] and area[1][1] == area[2][1] and area[0][1] != areaFree and area[1][1] != areaFree and area[2][1] != areaFree
  let line6 = area[0][2] == area[1][2] and area[1][2] == area[2][2] and area[0][2] != areaFree and area[1][2] != areaFree and area[2][2] != areaFree
  let line7 = area[0][0] == area[1][1] and area[1][1] == area[2][2] and area[0][0] != areaFree and area[1][1] != areaFree and area[2][2] != areaFree
  let line8 = area[0][2] == area[1][1] and area[1][1] == area[2][0] and area[0][2] != areaFree and area[1][1] != areaFree and area[2][0] != areaFree

  if line1 or line2 or line3 or line4 or line5 or line6 or line7 or line8:
    window.msgBox("おしまい")


window.show()
app.run()