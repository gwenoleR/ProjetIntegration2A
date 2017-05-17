#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/time.h>
#include "../../include/If_DBR.h"

#define strcmpi(dst, src) strcasecmp(dst, src)

const char * GetFormatStr(__int64 format)
{
	if (format == CODE_39)
		return "CODE_39";
	if (format == CODE_128)
		return "CODE_128";
	if (format == CODE_93)
		return "CODE_93";
	if (format == CODABAR)
		return "CODABAR";
	if (format == ITF)
		return "ITF";
	if (format == UPC_A)
		return "UPC_A";
	if (format == UPC_E)
		return "UPC_E";
	if (format == EAN_13)
		return "EAN_13";
	if (format == EAN_8)
		return "EAN_8";
	if (format == INDUSTRIAL_25)
		return "INDUSTRIAL_25";
	if (format == QR_CODE)
		return "QR_CODE";
	if (format == PDF417)
		return "PDF417";
	if (format == DATAMATRIX)
		return "DATAMATRIX";

	return "UNKNOWN";
}

int main(int argc, const char* argv[])
{
	const char *pszTestImage = "../../AllSupportedBarcodeTypes.tif";
	// Parse command
	__int64 llFormat = OneD | QR_CODE | PDF417 | DATAMATRIX;
	int iMaxCount = 0x7FFFFFFF;
	const char * pszImageFile = NULL;
	int iIndex = 0;
	ReaderOptions ro = {0};
	pBarcodeResultArray paryResult = NULL;
	int iRet = -1;
	struct timeval begin, end;
	float fCostTime = 0;

	pszImageFile = argv[1] ? argv[1] : pszTestImage;

	// Set license
	DBR_InitLicense("DA1A22E9291AC73457CCA00716346F1D");

	// Read barcode
	gettimeofday(&begin, NULL);
	ro.llBarcodeFormat = llFormat;
	ro.iMaxBarcodesNumPerPage = iMaxCount;
	iRet = DBR_DecodeFile(pszImageFile, &ro, &paryResult);
	gettimeofday(&end, NULL);

	// Output barcode result
	//if (iRet != DBR_OK)
	//{
	//	printf("Failed to read barcode: %s\n", DBR_GetErrorString(iRet));
	//	return 1;
	//}

	fCostTime = (float)((end.tv_sec * 1000 * 1000 +  end.tv_usec) - (begin.tv_sec * 1000 * 1000 + begin.tv_usec))/(1000 * 1000);
	if (paryResult->iBarcodeCount == 0)
	{
		printf("No barcode found. Total time spent: %.3f seconds.\n", fCostTime);
		DBR_FreeBarcodeResults(&paryResult);
		return 0;
	}

	printf("Total barcode(s) found: %d. Total time spent: %.3f seconds\n\n", paryResult->iBarcodeCount, fCostTime);
	for (iIndex = 0; iIndex < paryResult->iBarcodeCount; iIndex++)
	{
		printf("Barcode %d:\n", iIndex + 1);
		printf("    Page: %d\n", paryResult->ppBarcodes[iIndex]->iPageNum);
		printf("    Type: %s\n", GetFormatStr(paryResult->ppBarcodes[iIndex]->llFormat));
		printf("    Value: %s\n", paryResult->ppBarcodes[iIndex]->pBarcodeData);
		printf("    Region: {Left: %d, Top: %d, Width: %d, Height: %d}\n\n",
			paryResult->ppBarcodes[iIndex]->iLeft, paryResult->ppBarcodes[iIndex]->iTop,
			paryResult->ppBarcodes[iIndex]->iWidth, paryResult->ppBarcodes[iIndex]->iHeight);
	}

	DBR_FreeBarcodeResults(&paryResult);

	return 0;
}
