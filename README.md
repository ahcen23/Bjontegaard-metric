# Bjontegaard-metric
Updated integration limits to use the intersection of curves rather than the union, preventing polynomial extrapolation errors

The original Giuseppe Valenzise implementation (2010) (Available at: https://www.mathworks.com/matlabcentral/fileexchange/27798-bjontegaard-metric) integrates over the union of the ranges ([min(all), max(all)]). This forces the polynomial to extrapolate data where one curve is missing points.

The Risk: 3rd-order polynomials (polyfit) are numerically unstable outside the data range (Runge's phenomenon). Extrapolating even slightly can result in massive spikes or drops in the RD curve, rendering the calculated average completely wrong.

The Standard: The logic used in modern standardization (like JVET Common Test Conditions for VVC) strictly enforces integration over the overlapping interval ([max(min), min(max)]) to ensure the comparison is fair and based only on actual data.

