@echo off
set old_path="C:\Data\FDIC\SDI Old\All_Reports_20160930"
set new_path="C:\Data\Load\All_Reports_20160930"
echo Start comparing files in %new_path% and %old_path%
python header_compare.py %new_path% %old_path%
echo ------------------------------------------------------------------------------  
echo Files from
echo %new_path% 
echo and
echo %old_path%
echo are compared as shown above.
echo ------------------------------------------------------------------------------ 
mshta javascript:alert("Done. Find result in the console.");close();
@pause