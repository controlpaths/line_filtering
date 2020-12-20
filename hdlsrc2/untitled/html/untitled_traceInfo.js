function RTW_Sid2UrlHash() {
	this.urlHashMap = new Array();
	/* <S2>/filter */
	this.urlHashMap["untitled:4"] = "butterbp.v:72,73,74,75,76,77";
	this.getUrlHash = function(sid) { return this.urlHashMap[sid];}
}
RTW_Sid2UrlHash.instance = new RTW_Sid2UrlHash();
function RTW_rtwnameSIDMap() {
	this.rtwnameHashMap = new Array();
	this.sidHashMap = new Array();
	this.rtwnameHashMap["<Root>"] = {sid: "untitled"};
	this.sidHashMap["untitled"] = {rtwname: "<Root>"};
	this.rtwnameHashMap["<S2>/In"] = {sid: "untitled:3"};
	this.sidHashMap["untitled:3"] = {rtwname: "<S2>/In"};
	this.rtwnameHashMap["<S2>/filter"] = {sid: "untitled:4"};
	this.sidHashMap["untitled:4"] = {rtwname: "<S2>/filter"};
	this.rtwnameHashMap["<S2>/Out"] = {sid: "untitled:5"};
	this.sidHashMap["untitled:5"] = {rtwname: "<S2>/Out"};
	this.getSID = function(rtwname) { return this.rtwnameHashMap[rtwname];}
	this.getRtwname = function(sid) { return this.sidHashMap[sid];}
}
RTW_rtwnameSIDMap.instance = new RTW_rtwnameSIDMap();
