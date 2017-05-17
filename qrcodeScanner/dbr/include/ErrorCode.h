#ifndef __ERROR_CODE__
#define __ERROR_CODE__

#define DBR_OK 0

#define DBRERR_UNKNOWN				-10000
#define DBRERR_NOMEMORY				-10001	
#define DBRERR_NULL_POINTER			-10002	
#define DBRERR_LICENSE_INVALID		-10003	
#define DBRERR_LICENSE_EXPIRED		-10004	
#define DBRERR_FILE_NOT_FOUND		-10005	
#define DBRERR_FILETYPE_NOT_SUPPORT	-10006	
#define DBRERR_BPP_NOT_SUPPORT		-10007	
#define DBRERR_INDEX_INVALID		-10008
#define DBRERR_BARCODE_FORMAT_INVALID	-10009
#define DBRERR_CUSTOM_REGION_INVALID	-10010
#define DBRERR_MAX_BARCODE_NUMBER_INVALID	-10011
#define DBRERR_IMAGE_READ_FAIL		-10012
#define DBRERR_TIFF_READ_FAIL		-10013
#define DBRERR_FULL_USE_TRIAL_LICENSE -10014
#define DBRERR_TRIAL_USE_FULL_LICENSE -10015
#define DBRERR_QR_LICENSE_INVALID	-10016
#define DBRERR_1D_LICENSE_INVALID	-10017
#define DBRERR_INVALID_DIB_BUFFER   -10018
#define DBRERR_PDF417_LICENSE_INVALID -10019
#define DBRERR_DATAMATRIX_LICENSE_INVALID -10020
#define DBRERR_PDF_READ_FAIL		-10021
#define	DBRERR_PDF_DLL_MISS			-10022

#endif