# GIVEN SILL & HOSTROCK DIMENSIONS
# CALCULATE TOTAL MASS OF CARBON RELEASED, RELEASE TIME SCALE
# AND POWER LAW EXPONENT
#
# RADIAL VARIATION IN THICKNESS IS DEALT WITH 
# BY DIVIDING EACH SILL INTO N ANNULI OF CONSTANT AREA
# AND CALCULATING M, T, P SEPARATELY FOR EACH
#
# OUTPUT UNITS ARE PETA-GRAMS OF CARBON
#
# RANDOM NUMBERS TO DETERMINE TIME AND LOCATION ARE PASSED ON
# WITHOUT ALTERATION

BEGIN {

	test_dim2mt = 0;  # FOR TESTING AGAINST OLD VERSION OF dim2mt AND LIP_emission_model_1-3

# NUMBER OF ANNULI FOR CALCULATING RADIAL THICKNESS VARIATION

	N_annuli = 5;

# THRESHOLD FOR COUNTING AS A BIG SILL

	level = 5; 
	
# DENSITY OF MAGMA
# 1e3 kg/m3 = 1e12 kg/km3 = 1e9 Mg/km3 (or t/km3) = 1e3 Tg/km3

	denmag = 2750; 

# OTHER CONSTANTS

	pi = 3.141592654; 

# DIMENSIONLESS AUREOLE DEPENDENCE ON SILL THICKNESS AND DEPTH
	
n_YZ = 8;
YZ[1] = 0.0;
YZ[2] = 0.5;
YZ[3] = 1.0;
YZ[4] = 1.5;
YZ[5] = 2.0;
YZ[6] = 2.5;
YZ[7] = 3.0;
YZ[8] = 3.5;
n_YS = 6;
YS[1] = 0;
YS[2] = 50;
YS[3] = 100;
YS[4] = 200;
YS[5] = 300;
YS[6] = 400;
YLab[1][1] = 3.12688543182	# 0.0 0
YLab[2][1] = 3.34836794063	# 0.5 0
YLab[3][1] = 3.71395049989	# 1.0 0
YLab[4][1] = 4.2604704285	# 1.5 0
YLab[5][1] = 5.24141097534	# 2.0 0 
YLab[6][1] = 6.42592129484	# 2.5 0 
YLab[7][1] = 6.89300489798	# 3.0 0 
YLab[8][1] = 5.54773692042	# 3.5 0 
YLab[1][2] = 2.99456377141	# 0.0 50
YLab[2][2] = 3.5807	# 0.5 50
YLab[3][2] = 4.0622	# 1.0 50
YLab[4][2] = 4.5561	# 1.5 50
YLab[5][2] = 5.3701	# 2.0 50 
YLab[6][2] = 6.5378	# 2.5 50 
YLab[7][2] = 7.0991		# 3.0 50 
YLab[8][2] = 4.7633		# 3.5 50 
YLab[1][3] = 2.96241142135	# 0.0 100
YLab[2][3] = 3.8409	# 0.5 100 
YLab[3][3] = 4.5213	# 1.0 100 
YLab[4][3] = 4.3674	# 1.5 100 
YLab[5][3] = 6.8564	# 2.0 100 
YLab[6][3] = 5.2397	# 2.5 100 
YLab[7][3] = 7.913	# 3.0 100 
YLab[8][3] = 3.0911	# 3.5 100 
YLab[1][4] = 2.42088399362	# 0.0 200
YLab[2][4] = 3.7244	# 0.5 200 
YLab[3][4] = 5.5889	# 1.0 200 
YLab[4][4] = 7.7239	# 1.5 200 
YLab[5][4] = 8.8042	# 2.0 200 
YLab[6][4] = 7.71	# 2.5 200 
YLab[7][4] = 5.924	# 3.0 200 
YLab[8][4] = 4.5381	# 3.5 200 
YLab[1][5] = 1.81145532057	# 0.0 300
YLab[2][5] = 3.3243 		# 0.5 300 
YLab[3][5] = 6.4718	# 1.0 300 
YLab[4][5] = 7.996		# 1.5 300 
YLab[5][5] = 7.113	# 2.0 300 
YLab[6][5] = 5.7724		# 2.5 300 
YLab[7][5] = 4.7516	# 3.0 300 
YLab[8][5] = 4.0139	# 3.5 300 
YLab[1][6] = 1.88454088382	# 0.0 400
YLab[2][6] = 2.9279	# 0.5 400 
YLab[3][6] = 6.3213	# 1.0 400 
YLab[4][6] = 6.3234	# 1.5 400 
YLab[5][6] = 5.5202	# 2.0 400 
YLab[6][6] = 4.6713	# 2.5 400 
YLab[7][6] = 3.9375		# 3.0 400 
YLab[8][6] = 3.5338	# 3.5 400 
YRef[1][1] = 2.47756645642	# 0.0 0
YRef[2][1] = 2.46201500949	# 0.5 0 
YRef[3][1] = 2.58213095833	# 1.0 0 
YRef[4][1] = 2.71152534336	# 1.5 0 
YRef[5][1] = 2.92486460321	# 2.0 0 
YRef[6][1] = 3.29387549311	# 2.5 0 
YRef[7][1] = 3.82199482899	# 3.0 0 
YRef[8][1] = 4.37214955408	# 3.5 0 
YRef[1][2] = 2.30585208628	# 0.0 50
YRef[2][2] = 2.525	# 0.5 50 
YRef[3][2] = 2.8001	# 1.0 50 
YRef[4][2] = 3.0173	# 1.5 50 
YRef[5][2] = 3.3686	# 2.0 50 
YRef[6][2] = 3.8435	# 2.5 50 
YRef[7][2] = 4.4441	# 3.0 50 
YRef[8][2] = 5.2208	# 3.5 50 
YRef[1][3] = 2.26456134394	# 0.0 100
YRef[2][3] = 2.6619	# 0.5 100 
YRef[3][3] = 2.9673	# 1.0 100 
YRef[4][3] = 3.1832	# 1.5 100 
YRef[5][3] = 3.7531	# 2.0 100 
YRef[6][3] = 3.9474	# 2.5 100 
YRef[7][3] = 5.3941	# 3.0 100 
YRef[8][3] = 4.6709	# 3.5 100 
YRef[1][4] = 1.93646650994	# 0.0 200
YRef[2][4] = 2.695	# 0.5 200 
YRef[3][4] = 3.3483	# 1.0 200 
YRef[4][4] = 3.8272	# 1.5 200 
YRef[5][4] = 4.6498	# 2.0 200 
YRef[6][4] = 5.6913	# 2.5 200 
YRef[7][4] = 8.2603	# 3.0 200 
YRef[8][4] = 8.5613	# 3.5 200 
YRef[1][5] = 1.18829545565	# 0.0 300
YRef[2][5] = 2.3295	# 0.5 300 
YRef[3][5] = 3.5367	# 1.0 300 
YRef[4][5] = 4.6395	# 1.5 300 
YRef[5][5] = 6.8935	# 2.0 300 
YRef[6][5] = 7.1299	# 2.5 300 
YRef[7][5] = 8.0971	# 3.0 300 
YRef[8][5] = 7.52	# 3.5 300 
YRef[1][6] = 0.651893828996	# 0.0 400
YRef[2][6] = 1.969	# 0.5 400 
YRef[3][6] = 3.6557	# 1.0 400 
YRef[4][6] = 5.2587	# 1.5 400 
YRef[5][6] = 6.6896	# 2.0 400 
YRef[6][6] = 7.197	# 2.5 400 
YRef[7][6] = 6.9013	# 3.0 400 
YRef[8][6] = 6.1725	# 3.5 400 


# DIMENSIONLESS EMISSIONS DECAY TIME DEPENDENCE ON SILL THICKNESS AND DEPTH
# VARIABLE P
# FOUND BY parameterize_flux 15/8/18

n_TauZ = 8;
TauZ[1] = 0.0;
TauZ[2] = 0.5;
TauZ[3] = 1.0;
TauZ[4] = 1.5;
TauZ[5] = 2.0;
TauZ[6] = 2.5;
TauZ[7] = 3.0;
TauZ[8] = 3.5;
n_TauS = 6;
TauS[1] = 0;
TauS[2] = 50;
TauS[3] = 100;
TauS[4] = 200;
TauS[5] = 300;
TauS[6] = 400;
TauLab[1][1] = 0.242222419241	# 0.000000 0.000000
TauLab[2][1] = 0.432821760885	# 0.500000 0.000000
TauLab[3][1] = 0.534898594953	# 1.000000 0.000000
TauLab[4][1] = 0.670296757482	# 1.500000 0.000000
TauLab[5][1] = 1.07224549958	# 2.000000 0.000000
TauLab[6][1] = 1.86485193949	# 2.500000 0.000000
TauLab[7][1] = 2.95544584934	# 3.000000 0.000000
TauLab[8][1] = 3.93715812918	# 3.500000 0.000000
TauLab[1][2] = 0.163461717428	# 0.000000 50.000000
TauLab[2][2] = 0.60549120000000000000	# 0.500000 50.000000
TauLab[3][2] = 0.78209280000000000000	# 1.000000 50.000000
TauLab[4][2] = 0.99653760000000000000	# 1.500000 50.000000
TauLab[5][2] = 1.32451200000000000000	# 2.000000 50.000000
TauLab[6][2] = 1.94261760000000000000	# 2.500000 50.000000
TauLab[7][2] = 2.82562560000000000000	# 3.000000 50.000000
TauLab[8][2] = 3.63294720000000000000	# 3.500000 50.000000
TauLab[1][3] = 0.0830351830227	# 0.000000 100.000000
TauLab[2][3] = 0.65594880000000000000	# 0.500000 100.000000
TauLab[3][3] = 0.93977280000000000000	# 1.000000 100.000000
TauLab[4][3] = 1.52634240000000000000	# 1.500000 100.000000
TauLab[5][3] = 2.15706240000000000000	# 2.000000 100.000000
TauLab[6][3] = 1.81962720000000000000 # 2.500000 100.000000
TauLab[7][3] = 3.17882880000000000000	# 3.000000 100.000000
TauLab[8][3] = 1.87323840000000000000	# 3.500000 100.000000
TauLab[1][4] = 0.00600298936479	# 0.000000 200.000000
TauLab[2][4] = 0.55345680000000000000	# 0.500000 200.000000
TauLab[3][4] = 1.50347880000000000000	# 1.000000 200.000000
TauLab[4][4] = 3.44057760000000000000	# 1.500000 200.000000
TauLab[5][4] = 3.94357680000000000000	# 2.000000 200.000000
TauLab[6][4] = 2.31868440000000000000	# 2.500000 200.000000
TauLab[7][4] = 1.63829520000000000000	# 3.000000 200.000000
TauLab[8][4] = 2.65690800000000000000	# 3.500000 200.000000
TauLab[1][5] = 0.136596918455	# 0.000000 300.000000
TauLab[2][5] = 0.74950560000000000000	# 0.500000 300.000000
TauLab[3][5] = 2.68126080000000000000	# 1.000000 300.000000
TauLab[4][5] = 3.19354560000000000000	# 1.500000 300.000000
TauLab[5][5] = 1.51968480000000000000	# 2.000000 300.000000
TauLab[6][5] = 0.79085280000000000000	# 2.500000 300.000000
TauLab[7][5] = 1.05470400000000000000	# 3.000000 300.000000
TauLab[8][5] = 1.92334560000000000000	# 3.500000 300.000000
TauLab[1][6] = 0.369085384998 # 0.000000 400.000000
TauLab[2][6] = 1.06059510000000000000	# 0.500000 400.000000
TauLab[3][6] = 2.09773530000000000000	# 1.000000 400.000000
TauLab[4][6] = 1.06394580000000000000	# 1.500000 400.000000
TauLab[5][6] = 0.28342980000000000000	# 2.000000 400.000000
TauLab[6][6] = 0.43086060000000000000	# 2.500000 400.000000
TauLab[7][6] = 0.77953050000000000000	# 3.000000 400.000000
TauLab[8][6] = 1.71555840000000000000	# 3.500000 400.000000
TauRef[1][1] = 0.251688758843	# 0.000000 0.000000
TauRef[2][1] = 0.303204599826	# 0.500000 0.000000
TauRef[3][1] = 0.322223295283	# 1.000000 0.000000
TauRef[4][1] = 0.280522431131	# 1.500000 0.000000
TauRef[5][1] = 0.227647836437	# 2.000000 0.000000
TauRef[6][1] = 0.247211402864	# 2.500000 0.000000
TauRef[7][1] = 0.394396098563	# 3.000000 0.000000
TauRef[8][1] = 0.667700108839	# 3.500000 0.000000
TauRef[1][2] = 0.147045756865	# 0.000000 50.000000
TauRef[2][2] = 0.315360	# 0.500000 50.000000
TauRef[3][2] = 0.403661	# 1.000000 50.000000
TauRef[4][2] = 0.466733	# 1.500000 50.000000
TauRef[5][2] = 0.529805	# 2.000000 50.000000
TauRef[6][2] = 0.719021	# 2.500000 50.000000
TauRef[7][2] = 0.971309	# 3.000000 50.000000
TauRef[8][2] = 1.374970	# 3.500000 50.000000
TauRef[1][3] = 0.085598753416	# 0.000000 100.000000
TauRef[2][3] = 0.312206	# 0.500000 100.000000
TauRef[3][3] = 0.413122	# 1.000000 100.000000
TauRef[4][3] = 0.60864480	# 1.500000 100.000000
TauRef[5][3] = 0.703253	# 2.000000 100.000000
TauRef[6][3] = 1.05330240	# 2.500000 100.000000
TauRef[7][3] = 1.450656	# 3.000000 100.000000
TauRef[8][3] = 1.63671840	# 3.500000 100.000000
TauRef[1][4] = 0.0396332272794	# 0.000000 200.000000
TauRef[2][4] = 0.298804	# 0.500000 200.000000
TauRef[3][4] = 0.529016	# 1.000000 200.000000
TauRef[4][4] = 0.782093	# 1.500000 200.000000
TauRef[5][4] = 1.196791	# 2.000000 200.000000
TauRef[6][4] = 1.754978	# 2.500000 200.000000
TauRef[7][4] = 4.7162088	# 3.000000 200.000000
TauRef[8][4] = 4.091008	# 3.500000 200.000000
TauRef[1][5] = 0.0	# 0.000000 300.000000
TauRef[2][5] = 0.318514	# 0.500000 300.000000
TauRef[3][5] = 0.718320	# 1.000000 300.000000
TauRef[4][5] = 1.472381	# 1.500000 300.000000
TauRef[5][5] = 2.901662	# 2.000000 300.000000
TauRef[6][5] = 3.469310	# 2.500000 300.000000
TauRef[7][5] = 3.504000	# 3.000000 300.000000
TauRef[8][5] = 2.592259	# 3.500000 300.000000
TauRef[1][6] = 0.0	# 0.000000 400.000000
TauRef[2][6] = 0.33743520000000000000	# 0.500000 400.000000
TauRef[3][6] = 0.994764	# 1.000000 400.000000
TauRef[4][6] = 2.623007	# 1.500000 400.000000
TauRef[5][6] = 3.247222	# 2.000000 400.000000
TauRef[6][6] = 2.828385	# 2.500000 400.000000
TauRef[7][6] = 2.321050	# 3.000000 400.000000
TauRef[8][6] = 1.545461	# 3.500000 400.000000


# POWER DEPENDENCE ON SILL THICKNESS AND DEPTH

n_pZ = 8;
pZ[1] = 0.0;
pZ[2] = 0.5;
pZ[3] = 1.0;
pZ[4] = 1.5;
pZ[5] = 2.0;
pZ[6] = 2.5;
pZ[7] = 3.0;
pZ[8] = 3.5;
n_pS = 6;
pS[1] = 0;
pS[2] = 50;
pS[3] = 100;
pS[4] = 200;
pS[5] = 300;
pS[6] = 400;
pLab[1][1] = 0.723831238225	# 0.000000 0.000000
pLab[2][1] = 0.735397611046	# 0.500000 0.000000
pLab[3][1] = 0.753088334808	# 1.000000 0.000000
pLab[4][1] = 0.704991631443	# 1.500000 0.000000
pLab[5][1] = 0.646176204551	# 2.000000 0.000000
pLab[6][1] = 0.599194261711	# 2.500000 0.000000
pLab[7][1] = 0.562471980462	# 3.000000 0.000000
pLab[8][1] = 0.541438920656	# 3.500000 0.000000
pLab[1][2] = 0.565995313693	# 0.000000 50.000000
pLab[2][2] = 0.715	# 0.500000 50.000000
pLab[3][2] = 0.699	# 1.000000 50.000000
pLab[4][2] = 0.66	# 1.500000 50.000000
pLab[5][2] = 0.63	# 2.000000 50.000000
pLab[6][2] = 0.603	# 2.500000 50.000000
pLab[7][2] = 0.569	# 3.000000 50.000000
pLab[8][2] = 0.559	# 3.500000 50.000000
pLab[1][3] = 0.516014618333	# 0.000000 100.000000
pLab[2][3] = 0.69	# 0.500000 100.000000
pLab[3][3] = 0.638	# 1.000000 100.000000
pLab[4][3] = 0.695	# 1.500000 100.000000
pLab[5][3] = 0.576	# 2.000000 100.000000
pLab[6][3] = 0.645	# 2.500000 100.000000
pLab[7][3] = 0.568	# 3.000000 100.000000
pLab[8][3] = 0.645	# 3.500000 100.000000
pLab[1][4] = 0.545896028634	# 0.000000 200.000000
pLab[2][4] = 0.655	# 0.500000 200.000000
pLab[3][4] = 0.583	# 1.000000 200.000000
pLab[4][4] = 0.544	# 1.500000 200.000000
pLab[5][4] = 0.55	# 2.000000 200.000000
pLab[6][4] = 0.584	# 2.500000 200.000000
pLab[7][4] = 0.58	# 3.000000 200.000000
pLab[8][4] = 0.57	# 3.500000 200.000000
pLab[1][5] = 0.506745078601	# 0.000000 300.000000
pLab[2][5] = 0.553	# 0.500000 300.000000
pLab[3][5] = 0.538	# 1.000000 300.000000
pLab[4][5] = 0.558	# 1.500000 300.000000
pLab[5][5] = 0.622	# 2.000000 300.000000
pLab[6][5] = 0.645	# 2.500000 300.000000
pLab[7][5] = 0.582	# 3.000000 300.000000
pLab[8][5] = 0.577	# 3.500000 300.000000
pLab[1][6] = 0.483801719034	# 0.000000 400.000000
pLab[2][6] = 0.500	# 0.500000 400.000000
pLab[3][6] = 0.564	# 1.000000 400.000000
pLab[4][6] = 0.656	# 1.500000 400.000000
pLab[5][6] = 0.645	# 2.000000 400.000000
pLab[6][6] = 0.645	# 2.500000 400.000000
pLab[7][6] = 0.578	# 3.000000 400.000000
pLab[8][6] = 0.561	# 3.500000 400.000000
pRef[1][1] = 0.723479746841	# 0.000000 0.000000
pRef[2][1] = 0.74259798741	# 0.500000 0.000000
pRef[3][1] = 0.770104082301	# 1.000000 0.000000
pRef[4][1] = 0.729524864582	# 1.500000 0.000000
pRef[5][1] = 0.677899578353	# 2.000000 0.000000
pRef[6][1] = 0.640610436909	# 2.500000 0.000000
pRef[7][1] = 0.60012277239	# 3.000000 0.000000
pRef[8][1] = 0.563673265278	# 3.500000 0.000000
pRef[1][2] = 0.560715470463	# 0.000000 50.000000
pRef[2][2] = 0.715000	# 0.500000 50.000000
pRef[3][2] = 0.715000	# 1.000000 50.000000
pRef[4][2] = 0.670000	# 1.500000 50.000000
pRef[5][2] = 0.645000	# 2.000000 50.000000
pRef[6][2] = 0.645000	# 2.500000 50.000000
pRef[7][2] = 0.583000	# 3.000000 50.000000
pRef[8][2] = 0.570000	# 3.500000 50.000000
pRef[1][3] = 0.501742467983	# 0.000000 100.000000
pRef[2][3] = 0.646000	# 0.500000 100.000000
pRef[3][3] = 0.629000	# 1.000000 100.000000
pRef[4][3] = 0.695	# 1.500000 100.000000
pRef[5][3] = 0.598000	# 2.000000 100.000000
pRef[6][3] = 0.645	# 2.500000 100.000000
pRef[7][3] = 0.572000	# 3.000000 100.000000
pRef[8][3] = 0.645	# 3.500000 100.000000
pRef[1][4] = 0.536273767706	# 0.000000 200.000000
pRef[2][4] = 0.628000	# 0.500000 200.000000
pRef[3][4] = 0.623000	# 1.000000 200.000000
pRef[4][4] = 0.589000	# 1.500000 200.000000
pRef[5][4] = 0.567000	# 2.000000 200.000000
pRef[6][4] = 0.563000	# 2.500000 200.000000
pRef[7][4] = 0.521	# 3.000000 200.000000
pRef[8][4] = 0.538000	# 3.500000 200.000000
pRef[1][5] = 0.538279785542	# 0.000000 300.000000
pRef[2][5] = 0.620000	# 0.500000 300.000000
pRef[3][5] = 0.565000	# 1.000000 300.000000
pRef[4][5] = 0.541000	# 1.500000 300.000000
pRef[5][5] = 0.542000	# 2.000000 300.000000
pRef[6][5] = 0.530000	# 2.500000 300.000000
pRef[7][5] = 0.546000	# 3.000000 300.000000
pRef[8][5] = 0.561000	# 3.500000 300.000000
pRef[1][6] = 0.520425526891	# 0.000000 400.000000
pRef[2][6] = 0.565	# 0.500000 400.000000
pRef[3][6] = 0.538000	# 1.000000 400.000000
pRef[4][6] = 0.509000	# 1.500000 400.000000
pRef[5][6] = 0.533000	# 2.000000 400.000000
pRef[6][6] = 0.556000	# 2.500000 400.000000
pRef[7][6] = 0.566000	# 3.000000 400.000000
pRef[8][6] = 0.578000	# 3.500000 400.000000

# SPLIT THE SILL INTO ANNULI OF CONSTANT SURFACE AREA
# DETERMINE DLESS RADII FOR EACH ANNULUS ASSUMING CIRCULAR SILL

	r[0] = 0.0;
	r[N_annuli] = 1.0;
	for ( i=1; i<N_annuli; i++ ) r[i] = sqrt( 1.0 / N_annuli + r[i-1]^2);

}
{

# READ IN DIMENSION PARAMETERS FROM INPUT FILE

	A_full = $1;	# SILL SURFACE AREA (KM2)
	S_max = $2;		# SILL THICKNESS (M)
	W = $3;		# TOC TRANSFERRED TO METHANE CARBON
	Z = $4;		# DEPTH OF INTRUSION (KM)
	K = $5;		# PROPORTION LABILE:REFRACTORY KEROGEN
	TCP = $6;	# THICKNESS CORRECTION POWER
	ran_dt = $7;	# RANDOM NUMBER TO DETERMINE VARIATION IN INTRUSION TIME
	ran_lon = $8;	# RANDOM NUMBER TO DETERMINE LOCATION RADIUS
	ran_lat = $9;	# RANDOM NUMBER TO DETERMINE LOCATION AZIMUTH

# FIX PARAMETER AT A GIVEN VALUE, IF DESIRED

	if ( fix_A != 0 ) A = fix_A;	
	if ( fix_S != 0 ) S = fix_S;	
	if ( fix_W != 0 ) W = fix_W;	
	if ( fix_Z != 0 ) Z = fix_Z;	
	if ( fix_K != 0 ) K = fix_K;	
	
# HOST ROCK POROSITY AND DENSITY

	por = 0.63 * exp(-Z/2); 
	den = 1000*por + 2650*(1-por); 
	if ( fix_den != 0 ) den = fix_den;	

# SPLIT THE SILL INTO ANNULI OF CONSTANT SURFACE AREA

	A_ann = A_full / N_annuli;
	
# DETERMINE MEAN THICKNESS OF EACH ANNULUS
# (I_ANN = 0 IS THE MEAN FOR THE WHOLE SILL)

	thickness_correction_const = TCP+1;
	if (test_dim2mt == 1) {N = 0} else {N = N_annuli};
	for ( i_ann=0; i_ann<=N; i_ann++ ) {
		if ( i_ann == 0 ) {
			thickness_correction = 1.0 / thickness_correction_const;
			A = A_full;
		} else {
			thickness_correction = ( (1.0 - r[i_ann-1]^2/r[N_annuli]^2 )^thickness_correction_const - (1.0 - r[i_ann]^2/r[N_annuli]^2)^thickness_correction_const) / (thickness_correction_const * (r[i_ann]^2 - r[i_ann-1]^2));
			A = A_ann;
		}
#		print "Thickness correction: ", i_ann, thickness_correction;
		S = S_max * thickness_correction;
		if (test_dim2mt == 1) S = S_max;

# POWER LAW EXPONENT BY BILINEAR INTERPOLATION

		if ( S < pS[n_pS] ) {
			i_pS = 0;
			do { i_pS++ } while ( pS[i_pS] <= S );
			S0 = (S - pS[i_pS-1]) / (pS[i_pS] - pS[i_pS-1]);
		} else {
			i_pS = n_pS;
			S0 = 1;
		}
		if ( Z < pZ[n_pZ] ) {
			i_pZ = 1;
			while ( Z >= pZ[i_pZ] ) i_pZ++;
		} else {
			i_pZ = n_pZ;
		}
		p1Lab = pLab[i_pZ-1][i_pS-1] + (pLab[i_pZ-1][i_pS] - pLab[i_pZ-1][i_pS-1]) * S0;
		p1Ref = pRef[i_pZ-1][i_pS-1] + (pRef[i_pZ-1][i_pS] - pRef[i_pZ-1][i_pS-1]) * S0;
		p2Lab = pLab[i_pZ][i_pS-1] + (pLab[i_pZ][i_pS] - pLab[i_pZ][i_pS-1]) * S0;
		p2Ref = pRef[i_pZ][i_pS-1] + (pRef[i_pZ][i_pS] - pRef[i_pZ][i_pS-1]) * S0;
		if ( Z < pZ[n_pZ] ) {
			p_Lab = p1Lab + (p2Lab - p1Lab) * (Z - pZ[i_pZ-1]) / (pZ[i_pZ] - pZ[i_pZ-1]);
			p_Ref = p1Ref + (p2Ref - p1Ref) * (Z - pZ[i_pZ-1]) / (pZ[i_pZ] - pZ[i_pZ-1]);
		} else {
			p_Lab = p2Lab;
			p_Ref = p2Ref; 
		}
		p = K*p_Lab + (1-K)*p_Ref; 
		if ( fix_p != 0 ) p = fix_p;	

# AUREOLE WIDTHS BY BILINEAR INTERPOLATION

		if ( S < YS[n_YS] ) {
			i_YS = 0;
			do { i_YS++ } while ( YS[i_YS] <= S );
			S0 = (S - YS[i_YS-1]) / (YS[i_YS] - YS[i_YS-1]);
		} else {
			i_YS = n_YS;
			S0 = 1;
		}
		if ( Z < YZ[n_YZ] ) {
			i_YZ = 1;
			while ( Z >= YZ[i_YZ] ) i_YZ++;
		} else {
			i_YZ = n_YZ;
		}
		Y1Lab = YLab[i_YZ-1][i_YS-1] + (YLab[i_YZ-1][i_YS] - YLab[i_YZ-1][i_YS-1]) * S0;
		Y1Ref = YRef[i_YZ-1][i_YS-1] + (YRef[i_YZ-1][i_YS] - YRef[i_YZ-1][i_YS-1]) * S0;
		Y2Lab = YLab[i_YZ][i_YS-1] + (YLab[i_YZ][i_YS] - YLab[i_YZ][i_YS-1]) * S0;
		Y2Ref = YRef[i_YZ][i_YS-1] + (YRef[i_YZ][i_YS] - YRef[i_YZ][i_YS-1]) * S0;
		if ( Z < YZ[n_YZ] ) {
			Y_Lab = Y1Lab + (Y2Lab - Y1Lab) * (Z - YZ[i_YZ-1]) / (YZ[i_YZ] - YZ[i_YZ-1]);
			Y_Ref = Y1Ref + (Y2Ref - Y1Ref) * (Z - YZ[i_YZ-1]) / (YZ[i_YZ] - YZ[i_YZ-1]);
		} else {
			Y_Lab = Y2Lab;
			Y_Ref = Y2Ref; 
		}
		Y = K*Y_Lab + (1-K)*Y_Ref; 
	
# MASS OF METHANE

		mCH4_Lab = A * Y_Lab * den * W * S/1000; 
		mCH4_Ref = A * Y_Ref * den * W * S/1000; 
		mCH4 = K*mCH4_Lab + (1-K)*mCH4_Ref; 
		if ( fix_Y != 0 ) mCH4 = A * fix_Y * den * W * S/1000;	

# MASS OF CARBON DIOXIDE

		mCO2 = 0.27 * denmag * 0.005 * A * S/1000; 
	
# THERMAL TIME SCALE

		ttherm = S*S / 31.536; 

# TIME SCALES FOR EMISSIONS DECAY BY BILINEAR INTERPOLATION

		if ( S < TauS[n_TauS] ) {
			i_TauS = 0;
			do { i_TauS++ } while ( TauS[i_TauS] <= S );
			S0 = (S - TauS[i_TauS-1]) / (TauS[i_TauS] - TauS[i_TauS-1]);
		} else {
			i_TauS = n_TauS;
			S0 = 1;
		}
		if ( Z < TauZ[n_TauZ] ) {
			i_TauZ = 1;
			while ( Z >= TauZ[i_TauZ] ) i_TauZ++;
		} else {
			i_TauZ = n_TauZ;
		}
		t1Lab = TauLab[i_TauZ-1][i_TauS-1] + (TauLab[i_TauZ-1][i_TauS] - TauLab[i_TauZ-1][i_TauS-1]) * S0;
		t1Ref = TauRef[i_TauZ-1][i_TauS-1] + (TauRef[i_TauZ-1][i_TauS] - TauRef[i_TauZ-1][i_TauS-1]) * S0;
		t2Lab = TauLab[i_TauZ][i_TauS-1] + (TauLab[i_TauZ][i_TauS] - TauLab[i_TauZ][i_TauS-1]) * S0;
		t2Ref = TauRef[i_TauZ][i_TauS-1] + (TauRef[i_TauZ][i_TauS] - TauRef[i_TauZ][i_TauS-1]) * S0;
		if ( Z < TauZ[n_TauZ] ) {
			tdim_Lab = t1Lab + (t2Lab - t1Lab) * (Z - TauZ[i_TauZ-1]) / (TauZ[i_TauZ] - TauZ[i_TauZ-1]);
			tdim_Ref = t1Ref + (t2Ref - t1Ref) * (Z - TauZ[i_TauZ-1]) / (TauZ[i_TauZ] - TauZ[i_TauZ-1]);
		} else {
			tdim_Lab = t2Lab;
			tdim_Ref = t2Ref; 
		}
		tdecay_Lab = tdim_Lab * ttherm;
		tdecay_Ref = tdim_Ref * ttherm;
		tdecay = K*tdecay_Lab + (1-K)*tdecay_Ref; 

# TIME SCALES FOR VENTING, SOLIDIFICATION

		tvent = 10^(-2.05+1.39*Z); 
		tsol = 0.0147 -0.000141*S +0.00472*S*S; 

# COUNTING CONSECUTIVE BIG SILLS

		if ( i_ann == 0 && (mCH4/1000) >= level ) { Nconsec++ } else { Nconsec=0 }; 
	
# PRINT RESULTS
# 1. SILL SEQUENCE NUMBER
# 2. SUB-SILL SEQUENCE NUMBER (TO DEAL WITH VARIATION OF THICKNESS)
# 3. TOTAL NUMBER OF SUB-SILLS THIS SILL IS DIVIDED INTO
# 4. TOTAL MASS PER UNIT SURFACE AREA
# 5. MATURATION DECAY TIME
# 6. MATURATION POWER LAW EXPONENT
# 7. TOTAL MASS OF CO2 DEGASSED FROM MAGMA
# 8. TIME TO SOLIDIFICATION OF MAGMA
# 9. PROPORTION LABILE:REFRACTORY KEROGEN
# 10. RANDOM NUMBER TO DETERMINE VARIATION IN INTRUSION TIME
# 11. RANDOM NUMBER TO DETERMINE VARIATION IN LOCATION RADIUS
# 12. RANDOM NUMBER TO DETERMINE VARIATION IN LOCATION AZIMUTH
# 13. N CONSECUTIVE BIG SILLS (NOT USED HERE)
# 14. SILL SURFACE AREA
# 15. SILL MAXIMUM THICKNESS
# 16. SILL SCALED AUREOLE THICKNESS
# 17. SILL EMPLACEMENT DEPTH

		print NR, i_ann, N_annuli, mCH4/1000, tdecay, p, mCO2/1000, tsol, K, ran_dt, ran_lon, ran_lat, Nconsec, A, S, Y, Z;
#		print NR, i_ann, N_annuli, mCH4/1000, tdecay, p, mCO2/1000, tsol, Nconsec, ran_dt, ran_lon, ran_lat, Y_Lab, Y_Ref, Y, tdim_Lab, tdim_Ref, tdecay, ttherm, p_Lab, p_Ref, 1/TCP;

# END OF ANNULUS LOOP

	}
	
}



# DIMENSIONLESS EMISSIONS DECAY TIME DEPENDENCE ON SILL THICKNESS AND DEPTH
# THESE FOR POWER FIXED AT P=0.54

#n_TauZ = 7;
#TauZ[1] = 0.0;
#TauZ[2] = 0.5;
#TauZ[3] = 1.0;
#TauZ[4] = 1.5;
#TauZ[5] = 2.0;
#TauZ[6] = 2.5;
#TauZ[7] = 3.5;
#n_TauS = 6;
#TauS[1] = 0;
#TauS[2] = 50;
#TauS[3] = 100;
#TauS[4] = 200;
#TauS[5] = 300;
#TauS[6] = 400;
#TauLab[1][1] = 0.386386669241	# 0.0 0 
#TauLab[2][1] = 0.563007960794	# 0.5 0 
#TauLab[3][1] = 0.647330356296	# 1.0 0 
#TauLab[4][1] = 0.658952365397	# 1.5 0 
#TauLab[5][1] = 0.755395294167	# 2.0 0 
#TauLab[6][1] = 0.985900271684	# 2.5 0 
#TauLab[7][1] = 1.56954494677	# 3.5 0 
#TauLab[1][2] = 0.224004794494	# 0.0 50 
#TauLab[2][2] = 0.6559488	# 0.5 50 
#TauLab[3][2] = 0.7694784	# 1.0 50 
#TauLab[4][2] = 0.8956224	# 1.5 50 
#TauLab[5][2] = 1.0848384	# 2.0 50 
#TauLab[6][2] = 1.4128128	# 2.5 50 
#TauLab[7][2] = 1.9678464	# 3.5 50 
#TauLab[1][3] = 0.14958954812	# 0.0 100 
#TauLab[2][3] = 0.7852464	# 0.5 100 
#TauLab[3][3] = 0.9492336	# 1.0 100 
#TauLab[4][3] = 1.1605248	# 1.5 100 
#TauLab[5][3] = 1.5231888	# 2.0 100 
#TauLab[6][3] = 2.0056896	# 2.5 100 
#TauLab[7][3] = 2.7341712	# 3.5 100 
#TauLab[1][4] = 0.151536940597	# 0.0 200 
#TauLab[2][4] = 0.7324236	# 0.5 200 
#TauLab[3][4] = 1.2157128	# 1.0 200 
#TauLab[4][4] = 1.7683812	# 1.5 200 
#TauLab[5][4] = 2.1941172	# 2.0 200 
#TauLab[6][4] = 2.3447016	# 2.5 200 
#TauLab[7][4] = 3.1536000	# 3.5 200 
#TauLab[1][5] = 0.0446269738022	# 0.0 300 
#TauLab[2][5] = 0.5858688	# 0.5 300 
#TauLab[3][5] = 1.4436480	# 1.0 300 
#TauLab[4][5] = 2.0904864	# 1.5 300 
#TauLab[5][5] = 2.6031216	# 2.0 300 
#TauLab[6][5] = 3.0712560	# 2.5 300 
#TauLab[7][5] = 2.6644416	# 3.5 300 
#TauLab[1][6] = 0.00614529743325	# 0.0 400 
#TauLab[2][6] = 0.4767849	# 0.5 400 
#TauLab[3][6] = 1.4605110	# 1.0 400 
#TauLab[4][6] = 2.1426741	# 1.5 400 
#TauLab[5][6] = 2.8723383	# 2.0 400 
#TauLab[6][6] = 2.6622297	# 2.5 400 
#TauLab[7][6] = 1.7922303	# 3.5 400 
#TauRef[1][1] = 0.538899925421	# 0.0 0
#TauRef[2][1] = 0.534264717833	# 0.5 0
#TauRef[3][1] = 0.608964173007	# 1.0 0
#TauRef[4][1] = 0.612295086496	# 1.5 0
#TauRef[5][1] = 0.666479453444	# 2.0 0
#TauRef[6][1] = 0.823823571205	# 2.5 0
#TauRef[7][1] = 1.37769251363	# 3.5 0
#TauRef[1][2] = 0.217358436552	# 0.0 50
#TauRef[2][2] = 0.6054912	# 0.5 50 
#TauRef[3][2] = 0.6937920	# 1.0 50 
#TauRef[4][2] = 0.8199360	# 1.5 50 
#TauRef[5][2] = 0.9586944	# 1.5 50 
#TauRef[6][2] = 1.2235968	# 2.5 50 
#TauRef[7][2] = 1.8164736	# 3.5 50 
#TauRef[1][3] = 0.145848285872	# 0.0 100
#TauRef[2][3] = 0.7190208	# 0.5 100 
#TauRef[3][3] = 0.8514720	# 1.0 100 
#TauRef[4][3] = 1.0154592	# 1.5 100 
#TauRef[5][3] = 1.2772080	# 2.0 100 
#TauRef[6][3] = 1.6619472	# 2.5 100 
#TauRef[7][3] = 2.5449552	# 3.5 100 
#TauRef[1][4] = 0.151011659182	# 0.0 200
#TauRef[2][4] = 0.6725052	# 0.5 200 
#TauRef[3][4] = 1.0462068	# 1.0 200 
#TauRef[4][4] = 1.4254272	# 1.5 200 
#TauRef[5][4] = 1.8551052	# 2.0 200 
#TauRef[6][4] = 2.2453632	# 2.5 200 
#TauRef[7][4] = 3.1433508	# 3.5 200 
#TauRef[1][5] = 0.0384376191068	# 0.0 300
#TauRef[2][5] = 0.5298048	# 0.5 300 
#TauRef[3][5] = 1.2074784	# 1.0 300 
#TauRef[4][5] = 1.8381984	# 1.5 300 
#TauRef[5][5] = 2.5915584	# 2.0 300 
#TauRef[6][5] = 3.1938960	# 2.5 300 
#TauRef[7][5] = 2.7040368	# 3.5 300 
#TauRef[1][6] = 0.0000000	# 0.0 400
#TauRef[2][6] = 0.4233708	# 0.5 400 
#TauRef[3][6] = 1.2728718	# 1.0 400 
#TauRef[4][6] = 2.1071961	# 1.5 400 
#TauRef[5][6] = 2.9653695	# 2.0 400 
#TauRef[6][6] = 2.9399436	# 2.5 400 
#TauRef[7][6] = 1.9396611	# 3.5 400 


