#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include <magic.h>
#include <string.h>

#include "const-c.inc"

/* I don't know anything about perlxs, just trying by best. ;(
*/

MODULE = File::LibMagic		PACKAGE = File::LibMagic		

INCLUDE: const-xs.inc

PROTOTYPES: ENABLE

# First the two :easy functions
SV * MagicBuffer(buffer)
       SV * buffer
       PREINIT:
         char * ret;
         int len,ret_i;
         magic_t m;
       CODE:
	   /* First make sure they actually gave us a defined scalar */
	   if (SvTYPE(buffer) == SVt_NULL) {
	           /* RETVAL = &PL_sv_undef; */
		   RETVAL = newSV(0);
	   } else {
		   m  =magic_open(MAGIC_NONE); if (m==NULL) { printf("Error at open\n"); }
		   ret_i=magic_load(m,NULL);   if (ret_i<0) { printf("Error at load\n"); }
		   len=SvCUR(buffer);
		   ret=(char*) magic_buffer(m,SvPV(buffer,len),len);
		   magic_close(m);
		   RETVAL = newSVpvn(ret, strlen(ret));
	   }
       OUTPUT:
          RETVAL

SV * MagicFile(buffer)
       SV * buffer
       PREINIT:
         char * ret;
         int len,ret_i;
         magic_t m;
       CODE:
	   /* First make sure they actually gave us a defined scalar */
	   if (SvTYPE(buffer) == SVt_NULL) {
	           /* RETVAL = &PL_sv_undef; */
		   RETVAL = newSV(0);
	   } else {
		   m  =magic_open(MAGIC_NONE); if (m==NULL) { printf("Error at open\n"); }
		   ret_i=magic_load(m,NULL);   if (ret_i<0) { printf("Error at load\n"); }
		   len=SvCUR(buffer);
		   ret=(char*) magic_file(m,SvPV(buffer,len));
		   magic_close(m);
		   RETVAL = newSVpvn(ret, strlen(ret));
	   }
       OUTPUT:
          RETVAL

# now all :complete functions
IV   magic_open(flags)
       int flags
       PREINIT:
       	    magic_t m;
       CODE:
             m=magic_open(flags);
	     RETVAL=(int) m;
       OUTPUT:
       	     RETVAL

void magic_close(handle) 
	int handle
	PREINIT:
		magic_t m;
	CODE:
		// FIXME what if handle is undef
		m=(magic_t) handle;
		magic_close(m);

IV   magic_load(handle,dbnames)
	int handle
	SV * dbnames
	PREINIT:
		magic_t m;
		int ret;
	CODE:
		// FIXME what if handle is invalid
		m=(magic_t) handle;
		/* FIXME this is still to implement, i don't need it
		   right now. though leave it for now.
		*/
		// ret=magic_load(m,SvPV(dbnames,SvCUR(dbnames)));
		ret=magic_load(m,NULL);
		RETVAL=ret;
	OUTPUT:
		RETVAL

SV * magic_buffer(handle,buffer)
	int handle
	SV * buffer
	PREINIT:
		magic_t m;
		char * ret;
		int len;
	CODE:
	   // FIXME what if handle is invalid
	   /* First make sure they actually gave us a defined scalar */
	   if (SvTYPE(buffer) == SVt_NULL) {
	           /* RETVAL = &PL_sv_undef; */
		   RETVAL = newSV(0);
	   } else {
		    m=(magic_t) handle;
		    len=SvCUR(buffer);
		    ret=(char*) magic_buffer(m,SvPV(buffer,len),len);
		    RETVAL = newSVpvn(ret, strlen(ret));
	   }
	OUTPUT:
		RETVAL

SV * magic_file(handle,buffer)
       int handle
       SV * buffer
       PREINIT:
         char * ret;
         int len,ret_i;
         magic_t m;
       CODE:
	   /* First make sure they actually gave us a defined scalar */
	   if (SvTYPE(buffer) == SVt_NULL) {
	           /* RETVAL = &PL_sv_undef; */
		   RETVAL = newSV(0);
	   } else {
		   m=(magic_t) handle;
		   len=SvCUR(buffer);
		   ret=(char*) magic_file(m,SvPV(buffer,len));
		   RETVAL = newSVpvn(ret, strlen(ret));
	   }
       OUTPUT:
          RETVAL
