
function compareDates() {
	var date = new Date();
	var now = date.getTime().toString();
	// minor changes every 5 months
	// patch changes every 2 weeks
	// sub patch first number, changes every ~4 hours
	var str = '0.' + now.substr(2, 1) + '.' + now.substr(3, 1) + '.' + now.substr(4, 4);
	
	console.log('str: ' + str);
	/*
	var inx2 = now.substr(2);
	var pow = Math.pow(10, inx2.length - 1);
	console.log('inx2: ' + inx2 + ', pow: ' + pow);
	
	var test1s = Math.floor(parseInt(inx2) / pow) * pow;
	console.log('test1s: ' + test1s.toString());
	var test1 = parseInt(now.substr(0, 2) + test1s);
	var test1date = new Date(test1);
	console.log('test1date: ' + test1date.toString());
	
	var test2s = Math.ceil(parseInt(inx2) / pow) * pow;
	console.log('test2s: ' + test2s.toString());
	var test2 = parseInt(now.substr(0, 2) + test2s);
	var test2date = new Date(test2);
	console.log('test2date: ' + test2date.toString());
	
	var inx3 = now.substr(3);
	var pow = Math.pow(10, inx3.length - 1);
	console.log('inx3: ' + inx3 + ', pow: ' + pow);
	
	var test3s = Math.floor(parseInt(inx3) / pow) * pow;
	console.log('test3s: ' + test3s.toString());
	var test3 = parseInt(now.substr(0, 3) + test3s);
	var test3date = new Date(test3);
	console.log('test3date: ' + test3date.toString());
	
	var test4s = Math.ceil(parseInt(inx3) / pow) * pow;
	console.log('test4s: ' + test4s.toString());
	var test4 = parseInt(now.substr(0, 3) + test4s);
	var test4date = new Date(test4);
	console.log('test4date: ' + test4date.toString());
	
	var inx4 = now.substr(4);
	var pow = Math.pow(10, inx4.length - 1);
	console.log('inx4: ' + inx4 + ', pow: ' + pow);
	
	var test5s = Math.floor(parseInt(inx4) / pow) * pow;
	console.log('test5s: ' + test5s.toString());
	var test5 = parseInt(now.substr(0, 4) + test5s);
	var test5date = new Date(test5);
	console.log('test5date: ' + test5date.toString());
	
	var test6s = Math.ceil(parseInt(inx4) / pow) * pow;
	console.log('test6s: ' + test6s.toString());
	var test6 = parseInt(now.substr(0, 4) + test6s);
	var test6date = new Date(test6);
	console.log('test6date: ' + test6date.toString());
	*/
	
	var inx8 = now.substr(8);
	var pow8 = Math.pow(10, inx8.length - 1);
	var int8 = parseInt(inx8) / pow8;
	console.log('inx8: ' + inx8 + ', pow8: ' + pow8);
	
	var test7s = Math.floor(int8) * pow8;
	console.log('test7s: ' + test7s.toString());
	var test7 = parseInt(now.substr(0, 8) + test7s);
	var test7date = new Date(test7);
	console.log('test7date: ' + test7date.toString());
	
	var test8s = Math.ceil(int8) * pow8;
	console.log('test8s: ' + test8s.toString());
	var test8 = parseInt(now.substr(0, 8) + test8s);
	var test8date = new Date(test8);
	console.log('test8date: ' + test8date.toString());
}


//test7date: Wed Sep 08 2010 11:44:40 GMT+0300 (FLE Daylight Time)
//test8date: Wed Sep 08 2010 11:44:50 GMT+0300 (FLE Daylight Time)