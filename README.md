<h1 align="center">
  <img src="img/eye.png" alt="find-hardcoded" width="450px"></a>
  <br>

</h1>

<h1 align="center">
   MITM Detection & Preventions <img src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQeVOteejinhgpZJ_jPME-JwXaH84aHkVLUgVf2mzPgjYn0znu8lQuRpnBVGmt01lmhXLU&usqp=CAU" alt="find-hardcoded" width="25px"></a>
  <br>

</h1>


````
When you run 'detect.sh' it will open another terminal and it will show only ARP_Replay packet. Inspecting the packet you can easily identify the packet are crafted or Not. 

If 'detect.sh' capture worng mac address you can manually mentions the mac address of who sending the arp_reply packet 
and it will fetch you corresponding Ip Address of that.

````

## Usage
```
┌──(root㉿kali)-[~/Desktop/bash_script]
└─# bash arpspoofing.sh <target-ip>

OR

┌──(root㉿kali)-[~/Desktop/bash_script]
└─# bash arpspoofing_detect.sh. <interface name>
```

<h1 align="left">
  <img src="img/carbon_arpspoofing.svg" alt="OutPut" width="600px"></a>
  <br>
</h1>

<h1 align="left">
  <img src="img/carbon_arpspoofer_detect.svg" alt="OutPut" width="600px"></a>
  <br>
</h1>


##### Prerequisites
- apktool {apt install apktool} @iBotPeaches(https://github.com/iBotPeaches/Apktool)
<b> Note ! </b> 
