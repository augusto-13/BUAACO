#include<stdio.h>
int main(){
	for (int i=0; i<4; ++i) {
    int y = 350 + i * 110;
    for (int j=0; j<8; ++j) {
    int x = 230 + j * 190;
    printf("<wire from=\"(%d,%d)\" to=\"(%d,%d)\"/>\n",x, y, x+40, y);
    }
}
}
/*
<wire from="(230,50)" to="(270,50)"/>
*/
/*<comp lib="0" loc="(120,350)" name="Tunnel">
      <a name="facing" val="east"/>
      <a name="width" val="32"/>
      <a name="label" val="in0"/>
    </comp>
    */
/*
    <comp lib="4" loc="(180,350)" name="Register">
      <a name="width" val="32"/>
      <a name="label" val="r0"/>
    </comp>
    <comp lib="4" loc="(370,350)" name="Register">
      <a name="width" val="32"/>
      <a name="label" val="r1"/>
    <comp lib="4" loc="(180,460)" name="Register">
      <a name="width" val="32"/>
      <a name="label" val="r8"/>
    </comp>
*/
/*
    <comp lib="0" loc="(210,350)" name="Tunnel">
      <a name="width" val="32"/>
      <a name="label" val="out0"/>
    </comp>
     
<comp lib="0" loc="(400,350)" name="Tunnel">
      <a name="width" val="32"/>
      <a name="label" val="out1"/>
    </comp>
    <comp lib="0" loc="(210,460)" name="Tunnel">
      <a name="width" val="32"/>
      <a name="label" val="out8"/>
    </comp>
    <comp lib="0" loc="(310,350)" name="Tunnel">
      <a name="facing" val="east"/>
      <a name="width" val="32"/>
      <a name="label" val="in1"/>
    </comp>
    <comp lib="0" loc="(120,460)" name="Tunnel">
      <a name="facing" val="east"/>
      <a name="width" val="32"/>
      <a name="label" val="in8"/>
    </comp>
*/


/*
printf("<comp lib=\"0\" loc=\"(%d,%d)\" name=\"Tunnel\">\n",x, y);
    printf("<a name=\"width\" val=\"32\"/>\n");
    printf("<a name=\"label\" val=\"out%d\"/>\n", i * 8 + j);
    printf("</comp>\n");
*/

