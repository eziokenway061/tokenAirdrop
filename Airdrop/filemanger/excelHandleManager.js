/**
 * Created by zhaoyiyu on 2018/3/28.
 */

var xlsx = require('node-xlsx');
var fs = require('fs');

function readFile(path){

    //parse
    var obj = xlsx.parse(path);
    var excelObj=obj[0].data;
    console.log(excelObj);

    var data = [];
    for(var i in excelObj){
        var arr=[];
        var value=excelObj[i];
        for(var j in value){
            arr.push(value[j]);
        }
        data.push(arr);
    }

    return data;
}


function writeDataSync(data,path) {

    var buffer = xlsx.build([
        {
            name:'sheet1',
            data:data
        }
    ]);

    fs.writeFileSync(path,buffer,{'flag':'w'});
}

function appendData(data,path){
    var fs = require('fs');

    fs.exists(path,function (didExists) {

        if (didExists === false){

            console.log("need init recoder");

            var titleArr = [["Address","Amount"]];
            writeDataSync(titleArr,path)
        }


        var originalData = readFile(path);
        var appendData = originalData.concat(data);

        writeDataSync(appendData,path)
    });

}

function appendData2(data,path){
    var fs = require('fs');

    fs.exists(path,function (didExists) {

        if (didExists === false){

            console.log("need init recoder");

            var titleArr = [["id","privateKey","publicKey","ethAddress"]];
            writeDataSync(titleArr,path)
        }


        var originalData = readFile(path);
        var appendData = originalData.concat(data);

        writeDataSync(appendData,path)
    });

}


module.exports = {

    readExcelContent:readFile,
    writeDataToExcel:writeDataSync,
    recoderAirdrop:appendData,
    generateAddress:appendData2
};

// const data = [[ '0x1452dE977811e0e76f2Aad8dB7B3C95FdB052E63', 100 ],
// [ '0xa599169e409F16BeefB48A3b8DC6DAF55e96571d', 110 ],
// [ '0x8E34bD620743B2CE800DcFC462294333FC2d95c7', 120 ],
// [ '0xcF2d7b1aE22B58bcf5D97395fDF77e1d5d3f41a0', 130 ],
// [ '0x817FfA3d2F2028fcb9B8d2c619448cB3E3934c47', 140 ],
// [ '0x66f12855b202c2f8297f46632D956d7096Be966E', 150 ] ];

// appendData(data, './test.xlsx');