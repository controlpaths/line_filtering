function RTW_SidParentMap() {
    this.sidParentMap = new Array();
    this.sidParentMap["untitled:3"] = "untitled:2";
    this.sidParentMap["untitled:4"] = "untitled:2";
    this.sidParentMap["untitled:5"] = "untitled:2";
    this.getParentSid = function(sid) { return this.sidParentMap[sid];}
}
    RTW_SidParentMap.instance = new RTW_SidParentMap();
