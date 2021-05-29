from PIL import Image

pathToPeaksMap = "/Users/notahero/Desktop/procgen/noiseframe000.png"
im = Image.open(pathToPeaksMap)
px = im.load()
width, height = im.size

img = Image.new('RGB', (width, height), color = 'green')
px1 = img.load()

for i in range(width):
    for j in range(height):
        if(px[i,j] > 130):
            px1[j, i] = (200, 200, 200)

# for i in range(width):
#     for j in range(height):
#         if(px[i,j] < 120):
#             px1[i, j] = (0, 0, 200)
#         else:
#             px1[i, j] = (px[i, j],px[i, j],px[i, j])

img.save('/Users/notahero/Desktop/procgen/pil_red.png')
