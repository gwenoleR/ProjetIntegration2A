#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/time.h>
#include "../../include/If_DBRP.h"

#define strcmpi(dst, src) strcasecmp(dst, src)

struct barcode_format
{
	const char * pszFormat;
	__int64 llFormat;
};

static struct barcode_format Barcode_Formats[] =
{
	{"CODE_39", CODE_39},
	{"CODE_128", CODE_128},
	{"CODE_93", CODE_93},
	{"CODABAR", CODABAR},
	{"ITF", ITF},
	{"UPC_A", UPC_A},
	{"UPC_E", UPC_E},
	{"EAN_13", EAN_13},
	{"EAN_8", EAN_8},
	{"INDUSTRIAL_25", INDUSTRIAL_25},
	{"OneD", OneD},
	{"QR_CODE", QR_CODE},
	{"PDF417", PDF417},
	{"DATAMATRIX", DATAMATRIX}
};

const char * GetFormatStr(__int64 format)
{
	int iCount = sizeof(Barcode_Formats)/sizeof(Barcode_Formats[0]);

	for (int index = 0; index < iCount; index ++)
	{
		if (Barcode_Formats[index].llFormat == format)
			return Barcode_Formats[index].pszFormat;
	}

	return "UNKNOWN";
}

void PrintHelp()
{
	printf("Usage: BarcodeReaderDemo [ImageFilePath]\n");
}

int main(int argc, const char* argv[])
{
	const char *pszTestImage = "../../AllSupportedBarcodeTypes.tif";
	__int64 llFormat = OneD | QR_CODE | PDF417 | DATAMATRIX;
	int iMaxCount = 0x7FFFFFFF;
	const char * pszImageFile = NULL;
	int iIndex = 0;
	ReaderOptions ro = {0};
	int iRet = -1;
	struct timeval begin, end;
	float fCostTime = 0;

	pszImageFile = argv[1] ? argv[1] : pszTestImage;

	// Set license
	CBarcodeReader reader;
	reader.InitLicense("DA1A22E9291AC73457CCA00716346F1D");

	// Set Reader Options
	ro.llBarcodeFormat = llFormat;
	ro.iMaxBarcodesNumPerPage = iMaxCount;
	reader.SetReaderOptions(ro);

	// Read barcode
	gettimeofday(&begin, NULL);
	iRet = reader.DecodeFile(pszImageFile);
	gettimeofday(&end, NULL);

	// Output barcode result
	//if (iRet != DBR_OK)
	//{
	//	printf("Failed to read barcode: %s\n", DBR_GetErrorString(iRet));
	//	return 1;
	//}

	pBarcodeResultArray paryResult = NULL;
	reader.GetBarcodes(&paryResult);

	fCostTime = (float)((end.tv_sec * 1000 * 1000 +  end.tv_usec) - (begin.tv_sec * 1000 * 1000 + begin.tv_usec))/(1000 * 1000);
	if (paryResult->iBarcodeCount == 0)
	{
		printf("No barcode found. Total time spent: %.3f seconds.\n", fCostTime);
		CBarcodeReader::FreeBarcodeResults(&paryResult);
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

	CBarcodeReader::FreeBarcodeResults(&paryResult);

	return 0;
}
