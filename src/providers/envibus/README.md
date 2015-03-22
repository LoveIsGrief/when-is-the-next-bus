Envibus
=======

--------------------------------------------

Envibus does not provide an API so we have to do this ourselves.

# All busstop names and codes

Use `tools/envibus/envibus.bash` to create a JSON file with all
stations

```json
{
	"station code 1": "station name 1"
	//.
	//.
	//.
	"station code N": "station name N"
}
```

# Getting the list of buses

We might have to navigate through the forms
in order to get the list of buses for a station.

* http://tempsreel.envibus.fr/?ptano=<station code>

This will get a list of buses for that station that we can select.

They are in a table with cells like this.

<td width="10"></td><td valign="top"><input name="ligno" id="ligno1" value="999$1$453" type="checkbox"></td><td valign="top"><table border="0" cellpadding="0" cellspacing="0"><tbody><tr><td valign="top"><label for="ligno1"><img style="margin-right: 2px;" src="http://www.envibus.fr/image/ligne1.gif" alt="Ligne 1"></label></td><td>direction <b>AMPHORES</b></td></tr></tbody></table></td>

**TODO** Create a regex to get the line numbers