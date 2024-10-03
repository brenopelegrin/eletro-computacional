"""
  cycle2

Module that 

To run the main() function, call `julia main.jl` on the terminal.

Dependencies:
- Uses the MeshGenerator module to generate the mesh, MeshUpdater to update the mesh,
Gradient module to calculate the gradient of que potencial (Field) and Plots to plot the results.

Since:
- 09/2024

Authors:
- Pedro Calligaris Delbem <pedrodelbem@usp.br>
"""
module cycle2

    # Imports necessary modules
    include("./MeshGenerator.jl")
    include("./MeshUpdater.jl")
    include("./Gradient.jl")
    include("PlotAll.jl")
    using .MeshGenerator 
    using .MeshUpdater
    using .Gradient
    using .PlotAll

    function main()

        # define de mesh length
        side::Int = 3000
        minimum_iterations::Int = 10000

        # list of the poins with charge
        list_of_points::Vector{Tuple{Int, Int}} = [(48, 43),(49, 43),(50, 43),(51, 43),(52, 43),#I
                        (49, 47),(50, 47),(51, 47),(52, 47),(53, 47),
                        (48, 49),(49, 49),
                        (48, 51),(49, 51),#F
                        (49, 53),(50, 53),(51, 53),(51, 55),(53, 55),
                        (47, 54),(47, 55),
                        (51, 54),(51, 55),
                        (53, 54),(53, 55),#S
                        (47, 59),(48, 59),(49, 59),(50, 59),(51, 59),(52, 59),
                        (47, 60),(47, 61),
                        (53, 60),(53, 61)]

        two_charges::Vector{Tuple{Int, Int}}  = [(3,3), (9,9)]

        four_charges::Vector{Tuple{Int, Int}} = [(25,25), (25,75), (75,25), (75,75)]

        ampere::Vector{Tuple{Int, Int}} = [(2840, 642), (2818, 631), (2793, 627), (2768, 625), (2743, 624), (2751, 623), (2776, 622), (2801, 621), (2826, 617), (2835, 600), (2856, 611), (2861, 633), (2841, 646), (2558, 569), (2542, 550), (2549, 530), (2555, 548), (2571, 565), (2596, 567), (2618, 556), (2627, 533), (2629, 508), (2627, 483), (2607, 497), (2584, 507), (2559, 504), (2538, 491), (2522, 471), (2513, 448), (2511, 423), (2517, 399), (2533, 380), (2557, 376), (2581, 383), (2600, 399), (2615, 419), (2627, 441), (2638, 463), (2646, 487), (2649, 512), (2645, 536), (2632, 558), (2612, 572), (2588, 577), (2563, 572), (2558, 569), (2616, 462), (2611, 438), (2599, 416), (2581, 399), (2559, 387), (2537, 393), (2530, 417), (2531, 442), (2539, 466), (2553, 486), (2574, 498), (2598, 494), (2721, 563), (2731, 543), (2727, 519), (2721, 494), (2715, 470), (2707, 446), (2699, 422), (2688, 400), (2682, 382), (2707, 380), (2732, 380), (2757, 380), (2782, 380), (2807, 382), (2827, 396), (2839, 419), (2847, 442), (2832, 433), (2819, 412), (2800, 395), (2776, 390), (2751, 390), (2727, 394), (2722, 417), (2727, 442), (2733, 466), (2739, 490), (2745, 515), (2751, 539), (2764, 555), (2789, 557), (2814, 558), (2839, 557), (2852, 537), (2856, 513), (2859, 538), (2859, 563), (2841, 569), (2816, 569), (2791, 569), (2766, 568), (2740, 567), (2787, 498), (2774, 477), (2791, 458), (2802, 476), (2807, 501), (2796, 507), (1524, 471), (1511, 449), (1500, 426), (1492, 403), (1484, 379), (1479, 354), (1474, 330), (1471, 305), (1470, 280), (1469, 255), (1470, 230), (1472, 205), (1476, 180), (1481, 156), (1488, 132), (1498, 109), (1509, 86), (1521, 64), (1535, 43), (1550, 23), (1568, 18), (1555, 39), (1541, 59), (1529, 81), (1517, 103), (1506, 126), (1500, 150), (1497, 175), (1495, 200), (1495, 225), (1495, 250), (1495, 275), (1495, 300), (1495, 325), (1496, 350), (1499, 375), (1505, 400), (1515, 423), (1527, 445), (1539, 466), (1553, 487), (1565, 508), (1545, 497), (1529, 478), (2905, 500), (2918, 479), (2932, 458), (2944, 436), (2953, 413), (2960, 389), (2966, 364), (2971, 340), (2976, 315), (2978, 290), (2979, 265), (2979, 240), (2976, 215), (2972, 190), (2967, 166), (2960, 142), (2952, 118), (2943, 95), (2932, 72), (2918, 51), (2906, 29), (2918, 27), (2933, 47), (2946, 68), (2958, 90), (2969, 113), (2979, 136), (2987, 160), (2991, 184), (2993, 209), (2993, 234), (2993, 259), (2993, 285), (2992, 310), (2989, 335), (2986, 359), (2981, 384), (2974, 408), (2965, 431), (2953, 453), (2939, 474), (2922, 492), (2904, 500), (750, 451), (728, 440), (703, 437), (678, 435), (656, 433), (681, 432), (706, 431), (731, 429), (745, 415), (766, 427), (771, 450), (751, 456), (1775, 450), (1754, 440), (1729, 438), (1704, 437), (1679, 436), (1695, 434), (1720, 433), (1744, 430), (1764, 418), (1776, 416), (1791, 436), (1784, 458), (637, 374), (637, 349), (633, 324), (627, 299), (621, 275), (614, 251), (606, 228), (594, 205), (596, 191), (621, 190), (646, 190), (671, 191), (696, 196), (718, 207), (736, 224), (747, 246), (748, 271), (730, 288), (739, 307), (757, 323), (768, 345), (758, 367), (736, 379), (712, 386), (687, 389), (694, 373), (719, 369), (742, 361), (745, 337), (731, 317), (710, 303), (685, 298), (667, 294), (692, 288), (716, 281), (731, 262), (726, 237), (710, 218), (689, 205), (665, 200), (640, 202), (630, 223), (634, 248), (640, 272), (646, 297), (652, 321), (658, 345), (662, 370), (644, 383), (1680, 378), (1701, 369), (1706, 349), (1701, 324), (1695, 300), (1689, 275), (1683, 251), (1674, 228), (1661, 207), (1637, 200), (1626, 217), (1622, 239), (1609, 223), (1620, 201), (1642, 191), (1667, 196), (1685, 213), (1697, 235), (1705, 258), (1712, 282), (1718, 307), (1725, 331), (1733, 355), (1748, 373), (1732, 384), (1707, 385), (1682, 381), (53, 283), (64, 260), (75, 238), (86, 215), (98, 193), (111, 189), (124, 210), (135, 233), (147, 255), (158, 277), (169, 300), (181, 322), (192, 344), (203, 367), (199, 380), (174, 380), (149, 380), (124, 380), (99, 380), (73, 380), (48, 380), (23, 380), (6, 375), (17, 352), (28, 330), (40, 308), (51, 285), (52, 283), (141, 270), (129, 248), (116, 227), (100, 237), (87, 258), (75, 280), (63, 303), (52, 325), (42, 348), (62, 357), (87, 359), (112, 359), (137, 360), (162, 360), (187, 360), (177, 338), (165, 316), (153, 294), (1992, 310), (1994, 285), (1986, 269), (1961, 268), (1936, 267), (1911, 267), (1923, 265), (1948, 262), (1973, 259), (1989, 242), (1990, 217), (1992, 193), (2005, 186), (2009, 211), (2010, 236), (2020, 257), (2044, 262), (2069, 264), (2094, 266), (2070, 267), (2045, 268), (2020, 269), (2010, 284), (2010, 309), (2007, 334), (1993, 346), (1990, 321), (349, 296), (366, 278), (382, 260), (362, 244), (343, 227), (326, 209), (340, 208), (359, 224), (377, 241), (395, 248), (413, 231), (431, 214), (452, 200), (444, 219), (427, 237), (409, 255), (408, 272), (426, 290), (443, 309), (453, 329), (433, 315), (417, 296), (403, 275), (386, 278), (368, 296), (350, 313), (330, 327), (334, 312), (1171, 235), (1165, 210), (1159, 186), (1154, 161), (1150, 137), (1164, 143), (1172, 167), (1181, 190), (1204, 192), (1229, 196), (1249, 204), (1264, 190), (1284, 204), (1296, 226), (1283, 212), (1264, 205), (1265, 230), (1271, 254), (1277, 279), (1278, 303), (1261, 300), (1258, 275), (1252, 251), (1242, 228), (1227, 208), (1204, 200), (1190, 215), (1192, 240), (1196, 265), (1201, 290), (1207, 314), (1193, 306), (1184, 282), (1177, 258), (2276, 301), (2265, 278), (2266, 254), (2251, 237), (2253, 212), (2270, 196), (2295, 195), (2320, 197), (2338, 212), (2325, 210), (2302, 201), (2278, 205), (2265, 224), (2277, 244), (2302, 249), (2318, 263), (2294, 270), (2271, 276), (2282, 296), (2305, 304), (2330, 305), (2355, 301), (2343, 317), (2318, 319), (2294, 313), (1337, 288), (1323, 267), (1316, 243), (1313, 218), (1315, 193), (1322, 169), (1337, 150), (1360, 141), (1383, 149), (1395, 170), (1399, 195), (1400, 220), (1398, 245), (1392, 269), (1377, 289), (1355, 298), (1337, 288), (1387, 247), (1390, 222), (1388, 197), (1382, 173), (1368, 152), (1345, 154), (1333, 176), (1330, 200), (1330, 225), (1332, 250), (1340, 274), (1358, 289), (1377, 274), (2396, 284), (2385, 261), (2381, 236), (2380, 211), (2381, 186), (2386, 162), (2402, 144), (2427, 141), (2448, 153), (2457, 176), (2461, 201), (2461, 226), (2459, 251), (2453, 275), (2439, 295), (2415, 298), (2396, 284), (2446, 254), (2449, 229), (2449, 204), (2447, 180), (2438, 157), (2415, 150), (2396, 165), (2390, 189), (2390, 214), (2392, 239), (2398, 264), (2409, 286), (2432, 283), (913, 283), (937, 281), (962, 281), (987, 281), (1012, 283), (1000, 285), (975, 285), (950, 285), (925, 285), (902, 284), (2583, 263), (2607, 262), (2632, 261), (2657, 261), (2682, 261), (2708, 261), (2733, 261), (2758, 262), (2783, 263), (2793, 264), (2767, 265), (2742, 265), (2717, 265), (2692, 265), (2667, 265), (2642, 265), (2617, 265), (2592, 265), (2567, 264), (2577, 263), (873, 238), (896, 232), (921, 230), (946, 230), (971, 230), (996, 230), (1021, 231), (1046, 235), (1031, 242), (1006, 244), (981, 245), (956, 245), (931, 244), (906, 243), (881, 240), (2612, 188), (2600, 166), (2613, 150), (2618, 173), (2637, 188), (2661, 187), (2681, 172), (2688, 148), (2689, 123), (2677, 104), (2673, 79), (2666, 55), (2654, 33), (2636, 16), (2612, 10), (2590, 19), (2584, 43), (2588, 67), (2598, 90), (2615, 108), (2637, 119), (2662, 125), (2645, 128), (2620, 125), (2598, 113), (2581, 95), (2572, 71), (2572, 46), (2579, 22), (2596, 5), (2621, 1), (2645, 8), (2664, 23), (2680, 43), (2691, 65), (2700, 88), (2705, 113), (2706, 138), (2701, 162), (2688, 183), (2667, 196), (2642, 200), (2618, 193), (2767, 173), (2760, 149), (2747, 130), (2722, 126), (2744, 116), (2744, 91), (2739, 67), (2734, 42), (2732, 18), (2749, 2), (2773, 10), (2792, 26), (2796, 45), (2779, 26), (2761, 10), (2750, 28), (2753, 53), (2759, 77), (2768, 101), (2783, 120), (2791, 128), (2776, 144), (2779, 169)]

        current_list::Vector{Tuple{Int, Int}} = four_charges
        
        # create the mesh
        mesh::Matrix{Float64} = MeshGenerator.InitializeMesh(side, current_list)
        
        # atualize the mesh
        final_mesh::Matrix{Float64} = MeshUpdater.UpdateMesh(mesh, side, minimum_iterations, current_list)

        # compute the gradient of the potential
        Ex::Matrix{Float64}, Ey::Matrix{Float64} = Gradient.compute_gradient(final_mesh, side)

        # create the plot
        PlotAll.CreatePlot(final_mesh, side, current_list, Ex, Ey)


    end

end