float roundToInterval(float val, float precision, int decimals) {
    int integer = val * pow(10, decimals);
    int intPrecision = precision * pow(10, decimals);

    int intResult = round(integer / intPrecision) * intPrecision;
    return intResult / Math.pow(10, decimals);
}

int roundToInterval(int val, float precision) {
    int intResult = round(val / precision) * precision;
    return intResult
}