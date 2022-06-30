import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:retry/retry.dart';
import 'package:salesman/encrypt/enc.dart';
import 'package:salesman/widgets/custom_modals.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:salesman/url/url.dart';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._();
  static Database? _database;
  //TEST VERSION
  static final _dbName = 'DISTAPPDBB81.db';
  //LIVE VERSION
  // static final _dbName = 'DISTRIBUTION2.db';
  static final _dbVersion = 1;

  String globaldate =
      DateFormat("yyyy-MM-dd HH:mm:ss").format(new DateTime.now());

  DatabaseHelper._();

  factory DatabaseHelper() {
    return _instance;
  }

  Future<Database> get db async {
    if (_database != null) return _database!;

    _database = await init();
    return _database!;
  }

  Future<Database> init() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String dbPath = join(directory.path, _dbName);
    var database =
        openDatabase(dbPath, version: _dbVersion, onCreate: _onCreate);

    return database;
  }

  void _onCreate(Database db, int version) {
    db.execute('''
      CREATE TABLE myTable( 
        id INTEGER PRIMARY KEY,
        name TEXT)
       ''');

    ///CUSTOMER_MASTER_FILES
    db.execute('''
      CREATE TABLE customer_master_files(
        doc_no INTEGER PRIMARY KEY,
        customer_id TEXT,
        location_name TEXT,
        address1 TEXT,
        address2 TEXT,
        address3 TEXT,
        postal_address TEXT,
        account_group_code TEXT,
        account_group_name TEXT,
        account_code TEXT,
        account_name TEXT,
        account_description TEXT,
        account_credit_limit TEXT,
        account_classification_id TEXT,
        payment_type TEXT,
        salesman_code TEXT,
        status TEXT,
        cus_mobile_number TEXT,
        cus_password TEXT)''');

    ///ITEM MASTERFILE
    db.execute('''
      CREATE TABLE item_masterfiles(
        doc_no INTEGER PRIMARY KEY,
        item_masterfiles_id TEXT,
        product_name TEXT,
        company_code TEXT,
        itemcode TEXT,
        principal TEXT,
        product_family TEXT,
        uom TEXT,
        list_price_wtax TEXT,
        conversion_qty TEXT,
        isPromo TEXT,
        image TEXT,
        status TEXT)''');

    //ITEM IMAGE MASTERFILE
    db.execute('''
      CREATE TABLE tbl_item_image(
        doc_no INTEGER PRIMARY KEY,
        id TEXT,
        item_code TEXT,
        item_uom TEXT,
        item_path TEXT,
        image TEXT,
        created_at TEXT,
        updated_at TEXT)''');
    //or CLOB

    //ITEM CATEGORY MASTERFILE
    db.execute('''
      CREATE TABLE tbl_category_masterfile(
        doc_no INTEGER PRIMARY KEY,
        id TEXT,
        category_name TEXT,
        category_image TEXT)''');

    ///SALESMAN_LISTS
    db.execute('''
      CREATE TABLE salesman_lists(
        doc_no INTEGER PRIMARY KEY,
        id TEXT,
        username TEXT,
        password TEXT,
        first_name TEXT,
        last_name TEXT,
        department TEXT,
        division TEXT,
        area TEXT,
        district TEXT,
        title TEXT,
        product_line TEXT,
        address TEXT,
        postal_code TEXT,
        email TEXT,
        telephone TEXT,
        mobile TEXT,
        user_code TEXT,
        status TEXT,
        password_date TEXT,
        img TEXT)''');

    ///HEJE DE VIAJE TABLE
    db.execute('''
      CREATE TABLE tbl_hepe_de_viaje(
        doc_no INTEGER PRIMARY KEY,
        id TEXT,
        username TEXT,
        password TEXT,
        first_name TEXT,
        last_name TEXT,
        department TEXT,
        division TEXT,
        area TEXT,
        district TEXT,
        title TEXT,
        product_line TEXT,
        address TEXT,
        postal_code TEXT,
        email TEXT,
        telephone TEXT,
        mobile TEXT,
        user_code TEXT,
        assigned_warehouse TEXT,
        status TEXT,
        password_date TEXT,
        img TEXT)''');

    ///SALESMAN-HEPE
    db.execute('''
      CREATE TABLE tbl_hepe_salesman(
        doc_no INTEGER PRIMARY KEY,
        id TEXT,
        salesman_code TEXT,
        hepe_code TEXT,
        status TEXT)''');

    ///RETURNED TABLE
    db.execute('''
      CREATE TABLE tb_returned_tran(
        doc_no INTEGER PRIMARY KEY,
        tran_no TEXT,
        date TEXT,
        account_code TEXT,
        store_name TEXT,
        itm_count TEXT,
        tot_amt TEXT,
        hepe_code TEXT,
        reason TEXT,
        flag TEXT,
        signature TEXT,
        uploaded TEXT)''');

    ///SALESMAN TEMPORARY CART
    db.execute('''
      CREATE TABLE tb_salesman_cart(
        doc_no INTEGER PRIMARY KEY,
        salesman_code TEXT,
        account_code TEXT,
        item_code TEXT,
        item_desc TEXT,
        item_uom TEXT,
        item_amt TEXT,
        item_qty TEXT,
        item_total TEXT,
        item_cat TEXT,
        image TEXT)''');

    ///SALES TYPE
    db.execute('''
      CREATE TABLE tb_sales_type(
        doc_no INTEGER PRIMARY KEY,
        id TEXT,
        type TEXT,
        categ TEXT)''');

    ///TRANSACTION HEAD
    db.execute('''
      CREATE TABLE tb_tran_head(
        doc_no INTEGER PRIMARY KEY,
        id TEXT,
        tran_no TEXT,
        nav_invoice_no TEXT,
        date_req TEXT,
        date_app TEXT,
        date_transit TEXT,
        date_del TEXT,
        account_code TEXT,
        store_name TEXT,
        p_meth TEXT,
        itm_count TEXT,
        itm_del_count TEXT,
        tot_amt TEXT,
        tot_del_amt TEXT,
        pmeth_type TEXT,
        tran_stat TEXT,
        sm_code TEXT,
        hepe_code TEXT,
        order_by TEXT,
        flag TEXT,
        signature TEXT,
        auth_signature TEXT,
        isExported TEXT,
        export_date TEXT,
        rate_status TEXT,
        sm_upload TEXT,
        hepe_upload TEXT)''');

    ///TRANSACTION LINE
    db.execute('''
      CREATE TABLE tb_tran_line(
        doc_no INTEGER PRIMARY KEY,
        tran_no TEXT,
        nav_invoice_no TEXT,
        itm_code TEXT,
        item_desc TEXT,
        req_qty TEXT,
        del_qty TEXT,
        uom TEXT,
        amt TEXT,
        discount TEXT,
        tot_amt TEXT,
        discounted_amount TEXT,
        itm_cat TEXT,
        itm_stat TEXT,
        flag TEXT,
        account_code TEXT,
        date_req TEXT,
        date_del TEXT,
        lrate TEXT,
        rated TEXT,
        manually_included TEXT,
        image TEXT)''');

    ///UNSERVED ITEMS
    db.execute('''
      CREATE TABLE tb_unserved_items(
        doc_no INTEGER PRIMARY KEY,
        tran_no TEXT,
        date TEXT,
        itm_code TEXT,
        item_desc TEXT,
        qty TEXT,
        uom TEXT,
        amt TEXT,
        tot_amt TEXT,
        itm_cat TEXT,
        itm_stat TEXT,
        flag TEXT,
        image TEXT)''');

    ///UPDATE TABLES
    db.execute('''
      CREATE TABLE tb_tables_update(
        doc_no INTEGER PRIMARY KEY,
        tb_name TEXT,
        tb_categ TEXT,
        date TEXT,
        flag TEXT)''');

    ///UPDATE TABLES LOG
    db.execute('''
      CREATE TABLE tb_updates_log(
        doc_no INTEGER PRIMARY KEY,
        date TEXT,
        tb_categ TEXT,
        status TEXT,
        type TEXT)''');

    ///DISCOUNTS TABLE
    db.execute('''
      CREATE TABLE tbl_discounts(
        doc_no INTEGER PRIMARY KEY,
        id TEXT,
        cus_id TEXT,
        principal_id TEXT,
        discount TEXT,
        created_at TEXT,
        updated_at TEXT)''');

    ///BANK LIST FOR CHEQUE TABLE
    db.execute('''
      CREATE TABLE tb_bank_list (
        doc_no INTEGER PRIMARY KEY,
        bank_name TEXT)''');

    ///FAVORITES TABLE
    db.execute('''
      CREATE TABLE tb_favorites (
        doc_no INTEGER PRIMARY KEY,
        account_code TEXT,
        item_code TEXT,
        item_uom TEXT)''');

    ///CHEQUE DATA
    db.execute('''
      CREATE TABLE tb_cheque_data  (
        doc_no INTEGER PRIMARY KEY,
        tran_no TEXT,
        account_code TEXT,
        sm_code TEXT,
        hepe_code TEXT,
        datetime TEXT,
        payee_name TEXT,
        payor_name TEXT,
        bank_name TEXT,
        cheque_no TEXT,
        branch_code TEXT,
        account_no TEXT,
        cheque_date TEXT,
        amount TEXT,
        status TEXT,
        image TEXT)''');

    ///BANNER IMAGES TABLE
    db.execute('''
      CREATE TABLE tbl_banner_image (
        doc_no INTEGER PRIMARY KEY,
        banner_details TEXT,
        banner_img TEXT,
        img_path TEXT)''');

    ///BANNER USER ACCESS
    db.execute('''
      CREATE TABLE user_access (
        doc_no INTEGER PRIMARY KEY,
        ua_userid TEXT,
        ua_code TEXT,
        ua_action TEXT,
        ua_cust TEXT,
        ua_add_date TEXT,
        ua_update_date TEXT)''');

    print("Database was created!");
  }

  Future insertSalesmanList(salesman) async {
    var client = await db;
    Batch batch = client.batch();
    for (var i = 0; i < salesman.length; i++) {
      batch.insert('salesman_lists', salesman[i]);
    }
    await batch.commit(noResult: true);
  }

  Future insertHepeList(hepe) async {
    var client = await db;
    Batch batch = client.batch();
    for (var i = 0; i < hepe.length; i++) {
      batch.insert('tbl_hepe_de_viaje', hepe[i]);
    }
    await batch.commit(noResult: true);
  }

  Future insertCustomersList(customer) async {
    var client = await db;
    Batch batch = client.batch();
    for (var i = 0; i < customer.length; i++) {
      batch.insert('customer_master_files', customer[i]);
    }
    await batch.commit(noResult: true);
  }

  Future insertDiscountList(discount) async {
    var client = await db;
    Batch batch = client.batch();
    for (var i = 0; i < discount.length; i++) {
      batch.insert('tbl_discounts', discount[i]);
    }
    await batch.commit(noResult: true);
  }

  Future insertBankList(bank) async {
    var client = await db;
    Batch batch = client.batch();
    for (var i = 0; i < bank.length; i++) {
      batch.insert('tb_bank_list', bank[i]);
    }
    await batch.commit(noResult: true);
  }

  Future insertAccessList(access) async {
    var client = await db;
    Batch batch = client.batch();
    for (var i = 0; i < access.length; i++) {
      batch.insert('user_access', access[i]);
    }
    await batch.commit(noResult: true);
  }

  Future insertSalesTypeList(type) async {
    var client = await db;
    Batch batch = client.batch();
    for (var i = 0; i < type.length; i++) {
      batch.insert('tb_sales_type', type[i]);
    }
    await batch.commit(noResult: true);
  }

  Future insertItemList(items) async {
    var client = await db;
    Batch batch = client.batch();
    for (var i = 0; i < items.length; i++) {
      batch.insert('item_masterfiles', items[i]);
    }
    await batch.commit(noResult: true);
  }

  Future insertTable(list, tbName) async {
    var client = await db;
    Batch batch = client.batch();
    for (var i = 0; i < list.length; i++) {
      batch.insert('$tbName', list[i]);
    }
    await batch.commit(noResult: true);
  }

  // Future insertItemList(items, img) async {
  //   var client = await db;
  //   Batch batch = client.batch();
  //   for (var i = 0; i < items.length; i++) {
  //     batch.insert('item_masterfiles', items[i]);
  //     batch.update('item_masterfiles', {'image': img['image_path']},
  //         where: 'itemcode = ? AND uom = ?', whereArgs: []);
  //   }
  //   await batch.commit(noResult: true);
  // }

  Future insertItemImgList(img) async {
    var client = await db;
    Batch batch = client.batch();
    for (var i = 0; i < img.length; i++) {
      batch.insert('tbl_item_image', img[i]);
    }
    await batch.commit(noResult: true);
  }

  // Future updateItemImg(img) async {
  //   var client = await db;
  //   Batch batch = client.batch();
  //   for (var i = 0; i < img.length; i++) {
  //     batch.update('tbl_item_image', {'image': img[i]['image']},
  //         where: 'item_code = ? AND item_uom = ?',
  //         whereArgs: [img[i]['item_code'], img[i]['item_uom']]);
  //   }
  //   await batch.commit(noResult: true);
  // }
  Future updateItemImg(img) async {
    var client = await db;
    Batch batch = client.batch();
    for (var i = 0; i < img.length; i++) {
      batch.update('item_masterfiles', {'image': img[i]['item_path']},
          where: 'itemcode = ? AND uom = ?',
          whereArgs: [img[i]['item_code'], img[i]['item_uom']]);
    }
    await batch.commit(noResult: true);
  }

  Future insertCategList(categ) async {
    var client = await db;
    Batch batch = client.batch();
    for (var i = 0; i < categ.length; i++) {
      batch.insert('tbl_category_masterfile', categ[i]);
    }
    await batch.commit(noResult: true);
  }

  Future updateCategList(categ) async {
    var client = await db;
    Batch batch = client.batch();

    for (var i = 0; i < categ.length; i++) {
      batch.insert('tbl_category_masterfile', categ[i]);
      // batch.update('tbl_category_masterfile', categ[i],
      //     where: 'doc_no = ?', whereArgs: [categ[i]['doc_no']]);
    }
    await batch.commit(noResult: true);
  }

  Future deleteCateg() async {
    var client = await db;
    return client.rawQuery(
        'DELETE FROM tbl_category_masterfile WHERE category_name != " "', null);
  }

  Future deleteCustomer() async {
    var client = await db;
    return client.rawQuery(
        'DELETE FROM customer_master_files WHERE customer_id != " "', null);
  }

  Future deleteTable(tbNname) async {
    var client = await db;
    return client.rawQuery('DELETE FROM $tbNname WHERE doc_no !=" "', null);
  }

  Future addItemtoCart(salesmanCode, accountCode, itemCode, itemDesc, itemUom,
      itemAmt, qty, total, itemCat, itemImage) async {
    int fqty = 0;
    double ftotal = 0.00;
    var client = await db;

    List<Map> res = await client.rawQuery(
        'SELECT item_qty, item_total FROM tb_salesman_cart WHERE account_code ="$accountCode" AND  item_code = "$itemCode" AND item_uom = "$itemUom"',
        null);
    // final result = count;
    // return res;
    if (res.isEmpty) {
      return client.insert('tb_salesman_cart', {
        'salesman_code': salesmanCode,
        'account_code': accountCode,
        'item_code': itemCode,
        'item_desc': itemDesc,
        'item_uom': itemUom,
        'item_amt': itemAmt,
        'item_qty': qty,
        'item_total': total,
        'item_cat': itemCat,
        'image': itemImage,
      });
    } else {
      res.forEach((element) {
        fqty = int.parse(element['item_qty']);
        ftotal = double.parse(element['item_total']);
      });
      return client.update(
          'tb_salesman_cart',
          {
            'item_qty': (fqty + int.parse(qty)).toString(),
            'item_total': (ftotal + double.parse(total)).toString()
          },
          where: 'account_code = ? AND item_code = ? AND item_uom = ?',
          whereArgs: [accountCode, itemCode, itemUom]);
    }
  }

  Future addTempTranHead(tranNo, dateReq, accountCode, storeName, pMeth,
      itmCount, totAmt, tranStat, smCode, signature) async {
    String orderby = 'Salesman';
    String upStat = 'FALSE';
    double totalAmt = 0.00;
    int iCount = 0;
    var client = await db;

    List<Map> res = await client.rawQuery(
        'SELECT * FROM tb_tran_head WHERE tran_no ="$tranNo"', null);
    if (res.isEmpty) {
      return client.insert('tb_tran_head', {
        'tran_no': tranNo,
        'date_req': dateReq,
        'account_code': accountCode,
        'store_name': storeName,
        'p_meth': pMeth,
        'itm_count': itmCount,
        'tot_amt': totAmt,
        'tran_stat': tranStat,
        'sm_code': smCode,
        'order_by': orderby,
        'signature': signature,
        'sm_upload': upStat,
        'hepe_upload': upStat,
      });
    } else {
      res.forEach((element) {
        totalAmt = double.parse(element['tot_amt']);
        iCount = int.parse(element['itm_count']);
      });
      return client.update(
          'tb_tran_head',
          {
            'itm_count': (iCount + int.parse(itmCount)).toString(),
            'tot_amt': (totalAmt + double.parse(totAmt)).toString(),
          },
          where: 'tran_no = ?',
          whereArgs: [tranNo]);
    }
  }

  Future addTempTranLine(tranNo, itemCode, itemDesc, itemQty, itemUom, itemAmt,
      totAmt, itemCat, accountCode, date, image) async {
    int fqty = 0;
    double ftotal = 0.00;
    var client = await db;

    List<Map> res = await client.rawQuery(
        'SELECT req_qty, tot_amt FROM tb_tran_line WHERE tran_no ="$tranNo" AND account_code ="$accountCode" AND  itm_code = "$itemCode" AND uom = "$itemUom"',
        null);
    // final result = count;
    // return res;
    if (res.isEmpty) {
      return client.insert('tb_tran_line', {
        'tran_no': tranNo,
        'itm_code': itemCode,
        'item_desc': itemDesc,
        'req_qty': itemQty,
        'del_qty': '0',
        'uom': itemUom,
        'amt': itemAmt,
        'discount': '0',
        'tot_amt': totAmt,
        'discounted_amount': '0.00',
        'itm_cat': itemCat,
        'itm_stat': 'Pending',
        'flag': '0',
        'account_code': accountCode,
        'date_req': date,
        'image': image,
      });
    } else {
      res.forEach((element) {
        fqty = int.parse(element['req_qty']);
        ftotal = double.parse(element['tot_amt']);
      });
      return client.update(
          'tb_tran_line',
          {
            'req_qty': (fqty + int.parse(itemQty)).toString(),
            'tot_amt': (ftotal + double.parse(totAmt)).toString()
          },
          where:
              'tran_no = ? AND account_code = ? AND itm_code = ? AND uom = ?',
          whereArgs: [tranNo, accountCode, itemCode, itemUom]);
    }
  }

  Future addUpdateTable(tbName, tbCateg, date) async {
    var client = await db;
    return client.insert('tb_tables_update', {
      'tb_name': tbName,
      'tb_categ': tbCateg,
      'date': date,
    });
  }

  Future updateTable(tbName, date) async {
    var client = await db;
    return client.update('tb_tables_update', {'tb_name': tbName, 'date': date},
        where: 'tb_name = ?', whereArgs: [tbName]);
  }

  Future updateSalesmanPassword(code, pass) async {
    var client = await db;
    return client.update('salesman_lists', {'password': pass},
        where: 'user_code = ?', whereArgs: [code]);
  }

  Future updateHepePassword(code, pass) async {
    var client = await db;
    return client.update('tbl_hepe_de_viaje', {'password': pass},
        where: 'user_code = ?', whereArgs: [code]);
  }

  Future addUpdateTableLog(date, tbCateg, stat, type) async {
    var client = await db;
    return client.insert('tb_updates_log', {
      'date': date,
      'tb_categ': tbCateg,
      'status': stat,
      'type': type,
    });
  }

  Future updateCart(accountCode, itemCode, itemUom, itemQty, itemTotal) async {
    var client = await db;
    return client.update(
        'tb_salesman_cart', {'item_qty': itemQty, 'item_total': itemTotal},
        where: 'account_code = ? AND item_code = ? AND item_uom = ?',
        whereArgs: [accountCode, itemCode, itemUom]);

    // return 'UPDATED';
  }

  Future ofUpdateItemImg(image, itemcode, uom) async {
    var client = await db;
    return client.update('item_masterfiles', {'image': image},
        where: 'itemcode = ? AND uom = ?', whereArgs: [itemcode, uom]);
  }

  Future updateTranUploadStatSM(tmpTranNo, tranNo) async {
    String stat = 'TRUE';
    var client = await db;
    return client.update('tb_tran_head', {'tran_no': tranNo, 'sm_upload': stat},
        where: 'tran_no = ?', whereArgs: [tmpTranNo]);
  }

  Future updateTranUploadStatHEPE(tranNo) async {
    String stat = 'TRUE';
    var client = await db;
    return client.update('tb_tran_head', {'hepe_upload': stat},
        where: 'tran_no = ?', whereArgs: [tranNo]);
  }

  Future updateLineUploadStat(tmpTranNo, tranNo) async {
    var client = await db;
    return client.update('tb_tran_line', {'tran_no': tranNo},
        where: 'tran_no = ?', whereArgs: [tmpTranNo]);
  }

  // Future sampleUpdateItemImg(image, itemcode, uom) async {
  //   var client = await db;
  //   return client.update('tbl_item_image', {'item_path': image},
  //       where: 'item_code = ? AND item_uom = ?', whereArgs: [itemcode, uom]);
  // }

  Future ofFetchUpdatesTables() async {
    var client = await db;
    return client.rawQuery(
        'SELECT * FROM tb_tables_update ORDER BY date ASC', null);
  }

  Future ofFetchAll() async {
    var client = await db;
    return client.rawQuery('SELECT * FROM tb_bank_list ', null);
  }

  Future ofFetchSalesmanList() async {
    var client = await db;
    return client.rawQuery('SELECT * FROM salesman_lists', null);
  }

  Future ofFetchHepeList() async {
    var client = await db;
    return client.rawQuery('SELECT * FROM tbl_hepe_de_viaje', null);
  }

  Future ofFetchCustomerList() async {
    var client = await db;
    return client.rawQuery('SELECT * FROM customer_master_files', null);
  }

  Future ofFetchDiscountList() async {
    var client = await db;
    return client.rawQuery('SELECT * FROM tbl_discounts', null);
  }

  Future ofFetchBankList() async {
    var client = await db;
    return client.rawQuery('SELECT * FROM tb_bank_list', null);
  }

  Future ofFetchUserAccess() async {
    var client = await db;
    return client.rawQuery('SELECT * FROM user_access', null);
  }

  Future ofSalesTypeList() async {
    var client = await db;
    return client.rawQuery('SELECT * FROM tb_sales_type', null);
  }

  Future ofFetchItemList() async {
    var client = await db;
    return client.rawQuery('SELECT * FROM item_masterfiles', null);
  }

  Future ofFetchItemImgList() async {
    var client = await db;
    return client.rawQuery('SELECT * FROM tbl_item_image', null);
  }

  Future ofFetchCategList() async {
    var client = await db;
    return client.rawQuery('SELECT * FROM tbl_category_masterfile', null);
  }

  Future getReturnedList() async {
    var client = await db;
    return client.rawQuery('SELECT * FROM tb_returned_tran', null);
  }

  Future getReturnedStatus() async {
    // String stat = 'Returned';
    var client = await db;
    return client.rawQuery(
        'SELECT store_name, hepe_code,tran_stat FROM tb_tran_head', null);
  }

  Future getUnserveditems() async {
    var client = await db;
    return client.rawQuery('SELECT * FROM tb_unserved_items ', null);
  }

  Future ofFetchCart(custcode) async {
    var client = await db;

    return client.rawQuery(
        'SELECT * FROM tb_salesman_cart WHERE account_code ="$custcode" ORDER BY doc_no ASC',
        null);
  }

  Future searchCart(custcode, itmcode, uom) async {
    var client = await db;

    return client.rawQuery(
        'SELECT * FROM tb_salesman_cart WHERE account_code ="$custcode" AND item_code ="$itmcode" AND item_uom ="$uom"',
        null);
  }

  Future ofFetchSalesmanHistory(code) async {
    var client = await db;
    return client.rawQuery(
        "SELECT *,''as newdate FROM tb_tran_head WHERE sm_code ='$code' ORDER BY date_req ASC",
        null);
  }

  Future ofFetchSalesmanOngoingHistory(code) async {
    // String status = 'Delivered';
    var client = await db;
    return client.rawQuery(
        "SELECT *,''as newdate FROM tb_tran_head WHERE sm_code ='$code' AND tran_stat ='Pending' OR tran_stat ='On-Process' OR tran_stat ='Approved' ORDER BY date_app DESC",
        null);
  }

  Future ofFetchSalesmanCompletedHistory(code) async {
    String status = 'Delivered';
    var client = await db;
    return client.rawQuery(
        "SELECT *,''as newdate FROM tb_tran_head WHERE sm_code ='$code' AND tran_stat ='$status' ORDER BY date_del DESC",
        null);
  }

  Future ofFetchSalesmanCancelHistory(code) async {
    // String status = 'Delivered';
    var client = await db;
    return client.rawQuery(
        "SELECT *,''as newdate FROM tb_tran_head WHERE sm_code ='$code' AND tran_stat ='Cancelled' OR tran_stat ='Returned' ORDER BY date_del DESC",
        null);
  }

  Future ofFetchHepeHistory(code) async {
    var client = await db;
    return client.rawQuery(
        "SELECT *,'' as newdate FROM tb_tran_head WHERE hepe_code ='$code' ORDER BY date_req ASC",
        null);
  }

  Future ofFetchHepeOngoingHistory(code) async {
    var client = await db;
    return client.rawQuery(
        "SELECT *,'' as newdate FROM tb_tran_head WHERE hepe_code ='$code' AND tran_stat ='Pending' OR tran_stat ='On-Process' OR tran_stat ='Approved' ORDER BY date_app DESC",
        null);
  }

  Future ofFetchHepeCompletedHistory(code) async {
    String status = 'Delivered';
    var client = await db;
    return client.rawQuery(
        "SELECT *,'' as newdate FROM tb_tran_head WHERE hepe_code ='$code' AND tran_stat ='$status'  ORDER BY date_del DESC",
        null);
  }

  Future ofFetchHepeCancelHistory(code) async {
    var client = await db;
    return client.rawQuery(
        "SELECT *,'' as newdate FROM tb_tran_head WHERE hepe_code ='$code' AND tran_stat ='Cancelled' OR tran_stat ='Returned' ORDER BY date_del DESC",
        null);
  }

  Future ofFetchCustomerHistory(code) async {
    var client = await db;
    return client.rawQuery(
        'SELECT * FROM tb_tran_head WHERE account_code ="$code" ORDER BY date_req ASC',
        null);
  }

  Future ofFetchForUploadSalesmanSample(code) async {
    var client = await db;
    return client.rawQuery(
        'SELECT store_name FROM tb_tran_head WHERE sm_code ="$code" AND tran_stat ="Pending" AND sm_upload !="TRUE" ORDER BY account_code ASC',
        null);
  }

  Future ofFetchForUploadSalesman(code) async {
    var client = await db;
    return client.rawQuery(
        'SELECT * FROM tb_tran_head WHERE sm_code ="$code" AND tran_stat ="Pending" AND sm_upload !="TRUE" ORDER BY date_req ASC',
        null);
  }

  Future ofFetchForUploadHepe(code) async {
    var client = await db;
    return client.rawQuery(
        'SELECT * FROM tb_tran_head WHERE (tran_stat ="Delivered" OR tran_stat ="Returned") AND hepe_upload !="TRUE" ORDER BY date_del ASC',
        null);
  }

  Future ofFetchForUploadCustomer(code) async {
    var client = await db;
    return client.rawQuery(
        'SELECT tran_no FROM tb_tran_head WHERE account_code ="$code" AND tran_stat ="Pending" AND sm_upload !="TRUE" ORDER BY date_req ASC',
        null);
  }

  Future ofFetchUpdateLog(type) async {
    var client = await db;
    return client.rawQuery(
        'SELECT * FROM tb_updates_log WHERE type ="$type" ORDER BY doc_no DESC',
        null);
  }

  Future getAllProducts() async {
    var client = await db;
    return client.query('item_masterfiles',
        where: 'conversion_qty = ?', whereArgs: ['1']);
  }

  Future getProducts(categ) async {
    var client = await db;
    return client.rawQuery(
        'SELECT * FROM item_masterfiles WHERE product_family ="$categ" AND conversion_qty ="1"',
        null);
  }

  Future getUom(itmcode) async {
    var client = await db;
    return client.rawQuery(
        'SELECT * FROM item_masterfiles WHERE itemcode ="$itmcode"', null);
  }

  Future getOrderedItems(tranNo) async {
    var client = await db;
    return client.rawQuery(
        'SELECT * FROM tb_tran_line WHERE tran_no ="$tranNo" ORDER BY item_desc ASC',
        null);
  }

  Future getTransactionLine(tranNo) async {
    var client = await db;
    return client.rawQuery(
        'SELECT * FROM tb_tran_line WHERE tran_no ="$tranNo" ORDER BY item_desc ASC',
        null);
  }

  Future getReturnedTran(tranNo) async {
    var client = await db;
    return client.rawQuery(
        'SELECT * FROM tb_returned_tran WHERE tran_no ="$tranNo"', null);
  }

  Future getReturnedLine(tranNo) async {
    var client = await db;
    return client.rawQuery(
        'SELECT * FROM tb_unserved_items WHERE tran_no ="$tranNo"', null);
  }

  Future getItemImg(itmcode, uom) async {
    var client = await db;
    return client.rawQuery(
        'SELECT * FROM item_masterfiles WHERE itemcode ="$itmcode" AND uom="$uom"',
        null);
  }

  Future getItemImginTable(itmcode, uom) async {
    var client = await db;
    return client.rawQuery(
        'SELECT item_path FROM tbl_item_image WHERE item_code ="$itmcode" AND item_uom="$uom"',
        null);
  }

  Future getItemImgListloc(path) async {
    var client = await db;
    return client.rawQuery(
        'SELECT * FROM tbl_item_image WHERE item_path ="$path"', null);
  }

  Future getItemwithImg() async {
    String noImg = 'no_image_item.jpg';
    String caseImg = 'CASEE.png';
    String boxImg = 'BOXX.jpg';
    var client = await db;
    return client.rawQuery(
        'SELECT * FROM tbl_item_image WHERE item_path !="" AND item_path !="$noImg" AND item_path !="$caseImg" AND item_path !="$boxImg" LIMIT 3',
        null);
  }

  Future ofFetchItemPath(itmcode, uom) async {
    var client = await db;
    return client.rawQuery(
        'SELECT item_path FROM tbl_item_image WHERE item_code ="$itmcode" AND item_uom="$uom"',
        null);
  }

  Future setUom(itmcode, uom) async {
    var client = await db;
    return client.rawQuery(
        'SELECT * FROM item_masterfiles WHERE itemcode ="$itmcode" AND uom ="$uom"',
        null);
  }

  Future deleteItem(code, itmcode, uom) async {
    var client = await db;
    return client.rawQuery(
        'DELETE FROM tb_salesman_cart WHERE account_code ="$code" AND item_code ="$itmcode" AND item_uom ="$uom"',
        null);
  }

  Future deleteCart(code) async {
    var client = await db;
    return client.rawQuery(
        'DELETE FROM tb_salesman_cart WHERE account_code ="$code"', null);
  }

  Future searchAllItems(text) async {
    var client = await db;
    return client.rawQuery(
        "SELECT * FROM item_masterfiles WHERE product_name LIKE '%$text%' AND conversion_qty ='1' ",
        null);
  }

  Future searchItems(categ, text) async {
    var client = await db;
    return client.rawQuery(
        "SELECT * FROM item_masterfiles WHERE product_family ='$categ' AND product_name LIKE '%$text%' AND conversion_qty ='1'",
        null);
  }

  Future customerSearch(code, text) async {
    var client = await db;
    return client.rawQuery(
        "SELECT * FROM customer_master_files WHERE location_name LIKE '%$text%' AND salesman_code ='$code'",
        null);
  }

  Future salesmanHistorySearch(text) async {
    var client = await db;
    return client.rawQuery(
        "SELECT * FROM tb_tran_head WHERE store_name LIKE '%$text%'", null);
  }

  Future categSearch(text) async {
    var client = await db;
    return client.rawQuery(
        "SELECT * FROM tbl_category_masterfile WHERE category_name LIKE '%$text%'",
        null);
  }

  Future storeSearch(text) async {
    var client = await db;
    return client.rawQuery(
        "SELECT * FROM tb_tran_head WHERE store_name LIKE '%$text%' AND tran_stat ='Approved' AND hepe_upload = 'FALSE'  ORDER BY store_name ASC",
        null);
  }

  //OLD LOGIN CODE WITHOUT ACCOUNT LOCKED
  // Future salesmanLogin(username, password) async {
  //   var client = await db;
  //   var passwordF = md5.convert(utf8.encode(password));
  //   var res = client.rawQuery(
  //       "SELECT * FROM salesman_lists WHERE username = '$username' AND password = '$passwordF'",
  //       null);
  //   return res;
  // }
  Future salesmanLogin(username, password) async {
    var client = await db;
    var emp = '';
    var passwordF = md5.convert(utf8.encode(password));
    List<Map> res = await client.rawQuery(
        'SELECT username, (1) as attempt,(0) as success FROM salesman_lists WHERE username = "$username"',
        null);
    if (res.isEmpty) {
      return emp;
    } else {
      var rsp = await client.rawQuery(
          'SELECT *,(1) as success FROM salesman_lists WHERE username = "$username" AND password = "$passwordF" ',
          null);
      if (rsp.isEmpty) {
        return res;
      } else {
        return rsp;
      }
    }
  }

  //OLD LOGIN CODE WITHOUT ACCOUNT LOCKED
  // Future hepeLogin(username, password) async {
  //   var client = await db;
  //   var passwordF = md5.convert(utf8.encode(password));
  //   var res = client.rawQuery(
  //       "SELECT * FROM tbl_hepe_de_viaje WHERE username = '$username' AND password = '$passwordF'",
  //       null);
  //   return res;
  // }

  Future hepeLogin(username, password) async {
    var client = await db;
    var emp = '';
    var passwordF = md5.convert(utf8.encode(password));
    List<Map> res = await client.rawQuery(
        'SELECT username, (1) as attempt,(0) as success FROM tbl_hepe_de_viaje WHERE username = "$username"',
        null);
    if (res.isEmpty) {
      return emp;
    } else {
      var rsp = await client.rawQuery(
          'SELECT *,(1) as success FROM tbl_hepe_de_viaje WHERE username = "$username" AND password = "$passwordF" ',
          null);
      if (rsp.isEmpty) {
        return res;
      } else {
        return rsp;
      }
    }
  }

  Future checkSMusername(String username) async {
    var url = Uri.parse(UrlAddress.url + '/checksm');

    final response = await http.post(url,
        headers: {"Accept": "Application/json"},
        body: {'username': encrypt(username)});
    var convertedDatatoJson = jsonDecode(decrypt(response.body));
    return convertedDatatoJson;
  }

  ///
  ///
  ///
  ///
  ///
  /// MYSQL CODE
  ///
  ///
  ///
  ///
  ///
  ///
  ///

  Future checkHEPEusername(String username) async {
    var url = Uri.parse(UrlAddress.url + '/checkhepe');
    final response = await http.post(url,
        headers: {"Accept": "Application/json"},
        body: {'username': encrypt(username)});
    var convertedDatatoJson = jsonDecode(decrypt(response.body));
    return convertedDatatoJson;
  }

  Future viewCustomersList(String code) async {
    var client = await db;
    return client.rawQuery(
        'SELECT * FROM customer_master_files WHERE salesman_code = "$code" ORDER BY doc_no ASC LIMIT 100',
        null);
  }

  Future viewMultiCustomersList(String code) async {
    var client = await db;
    return client.rawQuery(
        'SELECT * FROM customer_master_files WHERE account_code = "$code" ORDER BY doc_no ASC LIMIT 100',
        null);
  }

  Future getSalesmanList(BuildContext context) async {
    // String url = UrlAddress.url + '/getsalesmanlist';
    try {
      var url = Uri.parse(UrlAddress.url + '/getsalesmanlist');
      final response = await retry(() =>
          http.post(url, headers: {"Accept": "Application/json"}, body: {}));
      if (response.statusCode == 200) {
        var convertedDatatoJson = jsonDecode(response.body);
        return convertedDatatoJson;
      } else if (response.statusCode >= 400 || response.statusCode <= 499) {
        customModal(
            context,
            Icon(CupertinoIcons.exclamationmark_circle,
                size: 50, color: Colors.red),
            Text(
                "Error: ${response.statusCode}. Your client has issued a malformed or illegal request.",
                textAlign: TextAlign.center),
            true,
            Icon(
              CupertinoIcons.checkmark_alt,
              size: 25,
              color: Colors.greenAccent,
            ),
            '',
            () {});
      } else if (response.statusCode >= 500 || response.statusCode <= 599) {
        customModal(
            context,
            Icon(CupertinoIcons.exclamationmark_circle,
                size: 50, color: Colors.red),
            Text("Error: ${response.statusCode}. Internal server error.",
                textAlign: TextAlign.center),
            true,
            Icon(
              CupertinoIcons.checkmark_alt,
              size: 25,
              color: Colors.greenAccent,
            ),
            '',
            () {});
      }
    } on TimeoutException {
      customModal(
          context,
          Icon(CupertinoIcons.exclamationmark_circle,
              size: 50, color: Colors.red),
          Text(
              "Connection timed out. Please check internet connection or proxy server configurations.",
              textAlign: TextAlign.center),
          true,
          Icon(
            CupertinoIcons.checkmark_alt,
            size: 25,
            color: Colors.greenAccent,
          ),
          'Okay',
          () {});
    } on SocketException {
      customModal(
          context,
          Icon(CupertinoIcons.exclamationmark_circle,
              size: 50, color: Colors.red),
          Text(
              "Connection timed out. Please check internet connection or proxy server configurations.",
              textAlign: TextAlign.center),
          true,
          Icon(
            CupertinoIcons.checkmark_alt,
            size: 25,
            color: Colors.greenAccent,
          ),
          'Okay',
          () {});
    } on HttpException {
      customModal(
          context,
          Icon(CupertinoIcons.exclamationmark_circle,
              size: 50, color: Colors.red),
          Text("An HTTP error eccured. Please try again later.",
              textAlign: TextAlign.center),
          true,
          Icon(
            CupertinoIcons.checkmark_alt,
            size: 25,
            color: Colors.greenAccent,
          ),
          'Okay',
          () {});
    } on FormatException {
      customModal(
          context,
          Icon(CupertinoIcons.exclamationmark_circle,
              size: 50, color: Colors.red),
          Text("Format exception error occured. Please try again later.",
              textAlign: TextAlign.center),
          true,
          Icon(
            CupertinoIcons.checkmark_alt,
            size: 25,
            color: Colors.greenAccent,
          ),
          'Okay',
          () {});
    }
  }

  Future getHepeList(BuildContext context) async {
    try {
      var url = Uri.parse(UrlAddress.url + '/gethepelist');
      final response = await retry(() =>
          http.post(url, headers: {"Accept": "Application/json"}, body: {}));
      if (response.statusCode == 200) {
        var convertedDatatoJson = jsonDecode(response.body);
        return convertedDatatoJson;
      } else if (response.statusCode >= 400 || response.statusCode <= 499) {
        customModal(
            context,
            Icon(CupertinoIcons.exclamationmark_circle,
                size: 50, color: Colors.red),
            Text(
                "Error: ${response.statusCode}. Your client has issued a malformed or illegal request.",
                textAlign: TextAlign.center),
            true,
            Icon(
              CupertinoIcons.checkmark_alt,
              size: 25,
              color: Colors.greenAccent,
            ),
            '',
            () {});
      } else if (response.statusCode >= 500 || response.statusCode <= 599) {
        customModal(
            context,
            Icon(CupertinoIcons.exclamationmark_circle,
                size: 50, color: Colors.red),
            Text("Error: ${response.statusCode}. Internal server error.",
                textAlign: TextAlign.center),
            true,
            Icon(
              CupertinoIcons.checkmark_alt,
              size: 25,
              color: Colors.greenAccent,
            ),
            '',
            () {});
      }
    } on TimeoutException {
      customModal(
          context,
          Icon(CupertinoIcons.exclamationmark_circle,
              size: 50, color: Colors.red),
          Text(
              "Connection timed out. Please check internet connection or proxy server configurations.",
              textAlign: TextAlign.center),
          true,
          Icon(
            CupertinoIcons.checkmark_alt,
            size: 25,
            color: Colors.greenAccent,
          ),
          'Okay',
          () {});
    } on SocketException {
      customModal(
          context,
          Icon(CupertinoIcons.exclamationmark_circle,
              size: 50, color: Colors.red),
          Text(
              "Connection timed out. Please check internet connection or proxy server configurations.",
              textAlign: TextAlign.center),
          true,
          Icon(
            CupertinoIcons.checkmark_alt,
            size: 25,
            color: Colors.greenAccent,
          ),
          'Okay',
          () {});
    } on HttpException {
      customModal(
          context,
          Icon(CupertinoIcons.exclamationmark_circle,
              size: 50, color: Colors.red),
          Text("An HTTP error eccured. Please try again later.",
              textAlign: TextAlign.center),
          true,
          Icon(
            CupertinoIcons.checkmark_alt,
            size: 25,
            color: Colors.greenAccent,
          ),
          'Okay',
          () {});
    } on FormatException {
      customModal(
          context,
          Icon(CupertinoIcons.exclamationmark_circle,
              size: 50, color: Colors.red),
          Text("Format exception error occured. Please try again later.",
              textAlign: TextAlign.center),
          true,
          Icon(
            CupertinoIcons.checkmark_alt,
            size: 25,
            color: Colors.greenAccent,
          ),
          'Okay',
          () {});
    }
  }

  Future getCustomersList(BuildContext context) async {
    try {
      var url = Uri.parse(UrlAddress.url + '/getcustomerslist');
      final response = await retry(() =>
          http.post(url, headers: {"Accept": "Application/json"}, body: {}));
      // var convertedDatatoJson = jsonDecode(decrypt(response.body));
      if (response.statusCode == 200) {
        var convertedDatatoJson = jsonDecode(response.body);
        return convertedDatatoJson;
      } else if (response.statusCode >= 400 || response.statusCode <= 499) {
        customModal(
            context,
            Icon(CupertinoIcons.exclamationmark_circle,
                size: 50, color: Colors.red),
            Text(
                "Error: ${response.statusCode}. Your client has issued a malformed or illegal request.",
                textAlign: TextAlign.center),
            true,
            Icon(
              CupertinoIcons.checkmark_alt,
              size: 25,
              color: Colors.greenAccent,
            ),
            '',
            () {});
      } else if (response.statusCode >= 500 || response.statusCode <= 599) {
        customModal(
            context,
            Icon(CupertinoIcons.exclamationmark_circle,
                size: 50, color: Colors.red),
            Text("Error: ${response.statusCode}. Internal server error.",
                textAlign: TextAlign.center),
            true,
            Icon(
              CupertinoIcons.checkmark_alt,
              size: 25,
              color: Colors.greenAccent,
            ),
            '',
            () {});
      }
    } on TimeoutException {
      customModal(
          context,
          Icon(CupertinoIcons.exclamationmark_circle,
              size: 50, color: Colors.red),
          Text(
              "Connection timed out. Please check internet connection or proxy server configurations.",
              textAlign: TextAlign.center),
          true,
          Icon(
            CupertinoIcons.checkmark_alt,
            size: 25,
            color: Colors.greenAccent,
          ),
          'Okay',
          () {});
    } on SocketException {
      customModal(
          context,
          Icon(CupertinoIcons.exclamationmark_circle,
              size: 50, color: Colors.red),
          Text(
              "Connection timed out. Please check internet connection or proxy server configurations.",
              textAlign: TextAlign.center),
          true,
          Icon(
            CupertinoIcons.checkmark_alt,
            size: 25,
            color: Colors.greenAccent,
          ),
          'Okay',
          () {});
    } on HttpException {
      customModal(
          context,
          Icon(CupertinoIcons.exclamationmark_circle,
              size: 50, color: Colors.red),
          Text("An HTTP error eccured. Please try again later.",
              textAlign: TextAlign.center),
          true,
          Icon(
            CupertinoIcons.checkmark_alt,
            size: 25,
            color: Colors.greenAccent,
          ),
          'Okay',
          () {});
    } on FormatException {
      customModal(
          context,
          Icon(CupertinoIcons.exclamationmark_circle,
              size: 50, color: Colors.red),
          Text("Format exception error occured. Please try again later.",
              textAlign: TextAlign.center),
          true,
          Icon(
            CupertinoIcons.checkmark_alt,
            size: 25,
            color: Colors.greenAccent,
          ),
          'Okay',
          () {});
    }
  }

  Future getDiscountList(BuildContext context) async {
    try {
      var url = Uri.parse(UrlAddress.url + '/getdiscountlist');
      final response = await retry(() =>
          http.post(url, headers: {"Accept": "Application/json"}, body: {}));
      if (response.statusCode == 200) {
        var convertedDatatoJson = jsonDecode(response.body);
        return convertedDatatoJson;
      } else if (response.statusCode >= 400 || response.statusCode <= 499) {
        customModal(
            context,
            Icon(CupertinoIcons.exclamationmark_circle,
                size: 50, color: Colors.red),
            Text(
                "Error: ${response.statusCode}. Your client has issued a malformed or illegal request.",
                textAlign: TextAlign.center),
            true,
            Icon(
              CupertinoIcons.checkmark_alt,
              size: 25,
              color: Colors.greenAccent,
            ),
            '',
            () {});
      } else if (response.statusCode >= 500 || response.statusCode <= 599) {
        customModal(
            context,
            Icon(CupertinoIcons.exclamationmark_circle,
                size: 50, color: Colors.red),
            Text("Error: ${response.statusCode}. Internal server error.",
                textAlign: TextAlign.center),
            true,
            Icon(
              CupertinoIcons.checkmark_alt,
              size: 25,
              color: Colors.greenAccent,
            ),
            '',
            () {});
      }
    } on TimeoutException {
      customModal(
          context,
          Icon(CupertinoIcons.exclamationmark_circle,
              size: 50, color: Colors.red),
          Text(
              "Connection timed out. Please check internet connection or proxy server configurations.",
              textAlign: TextAlign.center),
          true,
          Icon(
            CupertinoIcons.checkmark_alt,
            size: 25,
            color: Colors.greenAccent,
          ),
          'Okay',
          () {});
    } on SocketException {
      customModal(
          context,
          Icon(CupertinoIcons.exclamationmark_circle,
              size: 50, color: Colors.red),
          Text(
              "Connection timed out. Please check internet connection or proxy server configurations.",
              textAlign: TextAlign.center),
          true,
          Icon(
            CupertinoIcons.checkmark_alt,
            size: 25,
            color: Colors.greenAccent,
          ),
          'Okay',
          () {});
    } on HttpException {
      customModal(
          context,
          Icon(CupertinoIcons.exclamationmark_circle,
              size: 50, color: Colors.red),
          Text("An HTTP error eccured. Please try again later.",
              textAlign: TextAlign.center),
          true,
          Icon(
            CupertinoIcons.checkmark_alt,
            size: 25,
            color: Colors.greenAccent,
          ),
          'Okay',
          () {});
    } on FormatException {
      customModal(
          context,
          Icon(CupertinoIcons.exclamationmark_circle,
              size: 50, color: Colors.red),
          Text("Format exception error occured. Please try again later.",
              textAlign: TextAlign.center),
          true,
          Icon(
            CupertinoIcons.checkmark_alt,
            size: 25,
            color: Colors.greenAccent,
          ),
          'Okay',
          () {});
    }
  }

  Future getBankListonLine(BuildContext context) async {
    try {
      var url = Uri.parse(UrlAddress.url + '/getbanklist');
      final response = await retry(() =>
          http.post(url, headers: {"Accept": "Application/json"}, body: {}));
      if (response.statusCode == 200) {
        var convertedDatatoJson = jsonDecode(response.body);
        return convertedDatatoJson;
      } else if (response.statusCode >= 400 || response.statusCode <= 499) {
        customModal(
            context,
            Icon(CupertinoIcons.exclamationmark_circle,
                size: 50, color: Colors.red),
            Text(
                "Error: ${response.statusCode}. Your client has issued a malformed or illegal request.",
                textAlign: TextAlign.center),
            true,
            Icon(
              CupertinoIcons.checkmark_alt,
              size: 25,
              color: Colors.greenAccent,
            ),
            '',
            () {});
      } else if (response.statusCode >= 500 || response.statusCode <= 599) {
        customModal(
            context,
            Icon(CupertinoIcons.exclamationmark_circle,
                size: 50, color: Colors.red),
            Text("Error: ${response.statusCode}. Internal server error.",
                textAlign: TextAlign.center),
            true,
            Icon(
              CupertinoIcons.checkmark_alt,
              size: 25,
              color: Colors.greenAccent,
            ),
            '',
            () {});
      }
    } on TimeoutException {
      customModal(
          context,
          Icon(CupertinoIcons.exclamationmark_circle,
              size: 50, color: Colors.red),
          Text(
              "Connection timed out. Please check internet connection or proxy server configurations.",
              textAlign: TextAlign.center),
          true,
          Icon(
            CupertinoIcons.checkmark_alt,
            size: 25,
            color: Colors.greenAccent,
          ),
          'Okay',
          () {});
    } on SocketException {
      customModal(
          context,
          Icon(CupertinoIcons.exclamationmark_circle,
              size: 50, color: Colors.red),
          Text(
              "Connection timed out. Please check internet connection or proxy server configurations.",
              textAlign: TextAlign.center),
          true,
          Icon(
            CupertinoIcons.checkmark_alt,
            size: 25,
            color: Colors.greenAccent,
          ),
          'Okay',
          () {});
    } on HttpException {
      customModal(
          context,
          Icon(CupertinoIcons.exclamationmark_circle,
              size: 50, color: Colors.red),
          Text("An HTTP error eccured. Please try again later.",
              textAlign: TextAlign.center),
          true,
          Icon(
            CupertinoIcons.checkmark_alt,
            size: 25,
            color: Colors.greenAccent,
          ),
          'Okay',
          () {});
    } on FormatException {
      customModal(
          context,
          Icon(CupertinoIcons.exclamationmark_circle,
              size: 50, color: Colors.red),
          Text("Format exception error occured. Please try again later.",
              textAlign: TextAlign.center),
          true,
          Icon(
            CupertinoIcons.checkmark_alt,
            size: 25,
            color: Colors.greenAccent,
          ),
          'Okay',
          () {});
    }
  }

  Future getUserAccessonLine(BuildContext context) async {
    try {
      var url = Uri.parse(UrlAddress.url + '/getuseraccesslist');
      final response = await retry(() =>
          http.post(url, headers: {"Accept": "Application/json"}, body: {}));
      if (response.statusCode == 200) {
        var convertedDatatoJson = jsonDecode(response.body);
        return convertedDatatoJson;
      } else if (response.statusCode >= 400 || response.statusCode <= 499) {
        customModal(
            context,
            Icon(CupertinoIcons.exclamationmark_circle,
                size: 50, color: Colors.red),
            Text(
                "Error: ${response.statusCode}. Your client has issued a malformed or illegal request.",
                textAlign: TextAlign.center),
            true,
            Icon(
              CupertinoIcons.checkmark_alt,
              size: 25,
              color: Colors.greenAccent,
            ),
            '',
            () {});
      } else if (response.statusCode >= 500 || response.statusCode <= 599) {
        customModal(
            context,
            Icon(CupertinoIcons.exclamationmark_circle,
                size: 50, color: Colors.red),
            Text("Error: ${response.statusCode}. Internal server error.",
                textAlign: TextAlign.center),
            true,
            Icon(
              CupertinoIcons.checkmark_alt,
              size: 25,
              color: Colors.greenAccent,
            ),
            '',
            () {});
      }
    } on TimeoutException {
      customModal(
          context,
          Icon(CupertinoIcons.exclamationmark_circle,
              size: 50, color: Colors.red),
          Text(
              "Connection timed out. Please check internet connection or proxy server configurations.",
              textAlign: TextAlign.center),
          true,
          Icon(
            CupertinoIcons.checkmark_alt,
            size: 25,
            color: Colors.greenAccent,
          ),
          'Okay',
          () {});
    } on SocketException {
      customModal(
          context,
          Icon(CupertinoIcons.exclamationmark_circle,
              size: 50, color: Colors.red),
          Text(
              "Connection timed out. Please check internet connection or proxy server configurations.",
              textAlign: TextAlign.center),
          true,
          Icon(
            CupertinoIcons.checkmark_alt,
            size: 25,
            color: Colors.greenAccent,
          ),
          'Okay',
          () {});
    } on HttpException {
      customModal(
          context,
          Icon(CupertinoIcons.exclamationmark_circle,
              size: 50, color: Colors.red),
          Text("An HTTP error eccured. Please try again later.",
              textAlign: TextAlign.center),
          true,
          Icon(
            CupertinoIcons.checkmark_alt,
            size: 25,
            color: Colors.greenAccent,
          ),
          'Okay',
          () {});
    } on FormatException {
      customModal(
          context,
          Icon(CupertinoIcons.exclamationmark_circle,
              size: 50, color: Colors.red),
          Text("Format exception error occured. Please try again later.",
              textAlign: TextAlign.center),
          true,
          Icon(
            CupertinoIcons.checkmark_alt,
            size: 25,
            color: Colors.greenAccent,
          ),
          'Okay',
          () {});
    }
  }

  Future getSalesTypeListonLine(BuildContext context) async {
    try {
      var url = Uri.parse(UrlAddress.url + '/getallsalestype');
      final response = await retry(() =>
          http.post(url, headers: {"Accept": "Application/json"}, body: {}));
      if (response.statusCode == 200) {
        var convertedDatatoJson = jsonDecode(response.body);
        return convertedDatatoJson;
      } else if (response.statusCode >= 400 || response.statusCode <= 499) {
        customModal(
            context,
            Icon(CupertinoIcons.exclamationmark_circle,
                size: 50, color: Colors.red),
            Text(
                "Error: ${response.statusCode}. Your client has issued a malformed or illegal request.",
                textAlign: TextAlign.center),
            true,
            Icon(
              CupertinoIcons.checkmark_alt,
              size: 25,
              color: Colors.greenAccent,
            ),
            '',
            () {});
      } else if (response.statusCode >= 500 || response.statusCode <= 599) {
        customModal(
            context,
            Icon(CupertinoIcons.exclamationmark_circle,
                size: 50, color: Colors.red),
            Text("Error: ${response.statusCode}. Internal server error.",
                textAlign: TextAlign.center),
            true,
            Icon(
              CupertinoIcons.checkmark_alt,
              size: 25,
              color: Colors.greenAccent,
            ),
            '',
            () {});
      }
    } on TimeoutException {
      customModal(
          context,
          Icon(CupertinoIcons.exclamationmark_circle,
              size: 50, color: Colors.red),
          Text(
              "Connection timed out. Please check internet connection or proxy server configurations.",
              textAlign: TextAlign.center),
          true,
          Icon(
            CupertinoIcons.checkmark_alt,
            size: 25,
            color: Colors.greenAccent,
          ),
          'Okay',
          () {});
    } on SocketException {
      customModal(
          context,
          Icon(CupertinoIcons.exclamationmark_circle,
              size: 50, color: Colors.red),
          Text(
              "Connection timed out. Please check internet connection or proxy server configurations.",
              textAlign: TextAlign.center),
          true,
          Icon(
            CupertinoIcons.checkmark_alt,
            size: 25,
            color: Colors.greenAccent,
          ),
          'Okay',
          () {});
    } on HttpException {
      customModal(
          context,
          Icon(CupertinoIcons.exclamationmark_circle,
              size: 50, color: Colors.red),
          Text("An HTTP error eccured. Please try again later.",
              textAlign: TextAlign.center),
          true,
          Icon(
            CupertinoIcons.checkmark_alt,
            size: 25,
            color: Colors.greenAccent,
          ),
          'Okay',
          () {});
    } on FormatException {
      customModal(
          context,
          Icon(CupertinoIcons.exclamationmark_circle,
              size: 50, color: Colors.red),
          Text("Format exception error occured. Please try again later.",
              textAlign: TextAlign.center),
          true,
          Icon(
            CupertinoIcons.checkmark_alt,
            size: 25,
            color: Colors.greenAccent,
          ),
          'Okay',
          () {});
    }
  }

  // Future getChequeList() async {
  //   // String url = UrlAddress.url + '/getchequedata';
  //   var url = Uri.parse(UrlAddress.url + '/getchequedata');
  //   final response = await retry(() =>
  //       http.post(url, headers: {"Accept": "Application/json"}, body: {}));
  //   var convertedDatatoJson = jsonDecode(decrypt(response.body));
  //   return convertedDatatoJson;
  // }

  Future getItemList(BuildContext context) async {
    try {
      var url = Uri.parse(UrlAddress.url + '/getitemlist');
      final response = await retry(() =>
          http.post(url, headers: {"Accept": "Application/json"}, body: {}));
      if (response.statusCode == 200) {
        var convertedDatatoJson = jsonDecode(response.body);
        return convertedDatatoJson;
      } else if (response.statusCode >= 400 || response.statusCode <= 499) {
        customModal(
            context,
            Icon(CupertinoIcons.exclamationmark_circle,
                size: 50, color: Colors.red),
            Text(
                "Error: ${response.statusCode}. Your client has issued a malformed or illegal request.",
                textAlign: TextAlign.center),
            true,
            Icon(
              CupertinoIcons.checkmark_alt,
              size: 25,
              color: Colors.greenAccent,
            ),
            '',
            () {});
      } else if (response.statusCode >= 500 || response.statusCode <= 599) {
        customModal(
            context,
            Icon(CupertinoIcons.exclamationmark_circle,
                size: 50, color: Colors.red),
            Text("Error: ${response.statusCode}. Internal server error.",
                textAlign: TextAlign.center),
            true,
            Icon(
              CupertinoIcons.checkmark_alt,
              size: 25,
              color: Colors.greenAccent,
            ),
            '',
            () {});
      }
    } on TimeoutException {
      customModal(
          context,
          Icon(CupertinoIcons.exclamationmark_circle,
              size: 50, color: Colors.red),
          Text(
              "Connection timed out. Please check internet connection or proxy server configurations.",
              textAlign: TextAlign.center),
          true,
          Icon(
            CupertinoIcons.checkmark_alt,
            size: 25,
            color: Colors.greenAccent,
          ),
          'Okay',
          () {});
    } on SocketException {
      customModal(
          context,
          Icon(CupertinoIcons.exclamationmark_circle,
              size: 50, color: Colors.red),
          Text(
              "Connection timed out. Please check internet connection or proxy server configurations.",
              textAlign: TextAlign.center),
          true,
          Icon(
            CupertinoIcons.checkmark_alt,
            size: 25,
            color: Colors.greenAccent,
          ),
          'Okay',
          () {});
    } on HttpException {
      customModal(
          context,
          Icon(CupertinoIcons.exclamationmark_circle,
              size: 50, color: Colors.red),
          Text("An HTTP error eccured. Please try again later.",
              textAlign: TextAlign.center),
          true,
          Icon(
            CupertinoIcons.checkmark_alt,
            size: 25,
            color: Colors.greenAccent,
          ),
          'Okay',
          () {});
    } on FormatException {
      customModal(
          context,
          Icon(CupertinoIcons.exclamationmark_circle,
              size: 50, color: Colors.red),
          Text("Format exception error occured. Please try again later.",
              textAlign: TextAlign.center),
          true,
          Icon(
            CupertinoIcons.checkmark_alt,
            size: 25,
            color: Colors.greenAccent,
          ),
          'Okay',
          () {});
    }
  }

  Future getItemImgList(BuildContext context) async {
    try {
      var url = Uri.parse(UrlAddress.url + '/getitemimglist');
      final response = await retry(() =>
          http.post(url, headers: {"Accept": "Application/json"}, body: {}));
      if (response.statusCode == 200) {
        var convertedDatatoJson = jsonDecode(response.body);
        return convertedDatatoJson;
      } else if (response.statusCode >= 400 || response.statusCode <= 499) {
        customModal(
            context,
            Icon(CupertinoIcons.exclamationmark_circle,
                size: 50, color: Colors.red),
            Text(
                "Error: ${response.statusCode}. Your client has issued a malformed or illegal request.",
                textAlign: TextAlign.center),
            true,
            Icon(
              CupertinoIcons.checkmark_alt,
              size: 25,
              color: Colors.greenAccent,
            ),
            '',
            () {});
      } else if (response.statusCode >= 500 || response.statusCode <= 599) {
        customModal(
            context,
            Icon(CupertinoIcons.exclamationmark_circle,
                size: 50, color: Colors.red),
            Text("Error: ${response.statusCode}. Internal server error.",
                textAlign: TextAlign.center),
            true,
            Icon(
              CupertinoIcons.checkmark_alt,
              size: 25,
              color: Colors.greenAccent,
            ),
            '',
            () {});
      }
    } on TimeoutException {
      customModal(
          context,
          Icon(CupertinoIcons.exclamationmark_circle,
              size: 50, color: Colors.red),
          Text(
              "Connection timed out. Please check internet connection or proxy server configurations.",
              textAlign: TextAlign.center),
          true,
          Icon(
            CupertinoIcons.checkmark_alt,
            size: 25,
            color: Colors.greenAccent,
          ),
          'Okay',
          () {});
    } on SocketException {
      customModal(
          context,
          Icon(CupertinoIcons.exclamationmark_circle,
              size: 50, color: Colors.red),
          Text(
              "Connection timed out. Please check internet connection or proxy server configurations.",
              textAlign: TextAlign.center),
          true,
          Icon(
            CupertinoIcons.checkmark_alt,
            size: 25,
            color: Colors.greenAccent,
          ),
          'Okay',
          () {});
    } on HttpException {
      customModal(
          context,
          Icon(CupertinoIcons.exclamationmark_circle,
              size: 50, color: Colors.red),
          Text("An HTTP error eccured. Please try again later.",
              textAlign: TextAlign.center),
          true,
          Icon(
            CupertinoIcons.checkmark_alt,
            size: 25,
            color: Colors.greenAccent,
          ),
          'Okay',
          () {});
    } on FormatException {
      customModal(
          context,
          Icon(CupertinoIcons.exclamationmark_circle,
              size: 50, color: Colors.red),
          Text("Format exception error occured. Please try again later.",
              textAlign: TextAlign.center),
          true,
          Icon(
            CupertinoIcons.checkmark_alt,
            size: 25,
            color: Colors.greenAccent,
          ),
          'Okay',
          () {});
    }
  }

  Future getAllItemImgList(BuildContext context) async {
    try {
      var url = Uri.parse(UrlAddress.url + '/getallitemimglist');
      final response = await retry(() =>
          http.post(url, headers: {"Accept": "Application/json"}, body: {}));
      if (response.statusCode == 200) {
        var convertedDatatoJson = jsonDecode(response.body);
        return convertedDatatoJson;
      } else if (response.statusCode >= 400 || response.statusCode <= 499) {
        customModal(
            context,
            Icon(CupertinoIcons.exclamationmark_circle,
                size: 50, color: Colors.red),
            Text(
                "Error: ${response.statusCode}. Your client has issued a malformed or illegal request.",
                textAlign: TextAlign.center),
            true,
            Icon(
              CupertinoIcons.checkmark_alt,
              size: 25,
              color: Colors.greenAccent,
            ),
            '',
            () {});
      } else if (response.statusCode >= 500 || response.statusCode <= 599) {
        customModal(
            context,
            Icon(CupertinoIcons.exclamationmark_circle,
                size: 50, color: Colors.red),
            Text("Error: ${response.statusCode}. Internal server error.",
                textAlign: TextAlign.center),
            true,
            Icon(
              CupertinoIcons.checkmark_alt,
              size: 25,
              color: Colors.greenAccent,
            ),
            '',
            () {});
      }
    } on TimeoutException {
      customModal(
          context,
          Icon(CupertinoIcons.exclamationmark_circle,
              size: 50, color: Colors.red),
          Text(
              "Connection timed out. Please check internet connection or proxy server configurations.",
              textAlign: TextAlign.center),
          true,
          Icon(
            CupertinoIcons.checkmark_alt,
            size: 25,
            color: Colors.greenAccent,
          ),
          'Okay',
          () {});
    } on SocketException {
      customModal(
          context,
          Icon(CupertinoIcons.exclamationmark_circle,
              size: 50, color: Colors.red),
          Text(
              "Connection timed out. Please check internet connection or proxy server configurations.",
              textAlign: TextAlign.center),
          true,
          Icon(
            CupertinoIcons.checkmark_alt,
            size: 25,
            color: Colors.greenAccent,
          ),
          'Okay',
          () {});
    } on HttpException {
      customModal(
          context,
          Icon(CupertinoIcons.exclamationmark_circle,
              size: 50, color: Colors.red),
          Text("An HTTP error eccured. Please try again later.",
              textAlign: TextAlign.center),
          true,
          Icon(
            CupertinoIcons.checkmark_alt,
            size: 25,
            color: Colors.greenAccent,
          ),
          'Okay',
          () {});
    } on FormatException {
      customModal(
          context,
          Icon(CupertinoIcons.exclamationmark_circle,
              size: 50, color: Colors.red),
          Text("Format exception error occured. Please try again later.",
              textAlign: TextAlign.center),
          true,
          Icon(
            CupertinoIcons.checkmark_alt,
            size: 25,
            color: Colors.greenAccent,
          ),
          'Okay',
          () {});
    }
  }

  Future getCategList(BuildContext context) async {
    try {
      var url = Uri.parse(UrlAddress.url + '/getcateglist');
      final response = await retry(() =>
          http.post(url, headers: {"Accept": "Application/json"}, body: {}));
      if (response.statusCode == 200) {
        var convertedDatatoJson = jsonDecode(response.body);
        return convertedDatatoJson;
      } else if (response.statusCode >= 400 || response.statusCode <= 499) {
        customModal(
            context,
            Icon(CupertinoIcons.exclamationmark_circle,
                size: 50, color: Colors.red),
            Text(
                "Error: ${response.statusCode}. Your client has issued a malformed or illegal request.",
                textAlign: TextAlign.center),
            true,
            Icon(
              CupertinoIcons.checkmark_alt,
              size: 25,
              color: Colors.greenAccent,
            ),
            '',
            () {});
      } else if (response.statusCode >= 500 || response.statusCode <= 599) {
        customModal(
            context,
            Icon(CupertinoIcons.exclamationmark_circle,
                size: 50, color: Colors.red),
            Text("Error: ${response.statusCode}. Internal server error.",
                textAlign: TextAlign.center),
            true,
            Icon(
              CupertinoIcons.checkmark_alt,
              size: 25,
              color: Colors.greenAccent,
            ),
            '',
            () {});
      }
    } on TimeoutException {
      customModal(
          context,
          Icon(CupertinoIcons.exclamationmark_circle,
              size: 50, color: Colors.red),
          Text(
              "Connection timed out. Please check internet connection or proxy server configurations.",
              textAlign: TextAlign.center),
          true,
          Icon(
            CupertinoIcons.checkmark_alt,
            size: 25,
            color: Colors.greenAccent,
          ),
          'Okay',
          () {});
    } on SocketException {
      customModal(
          context,
          Icon(CupertinoIcons.exclamationmark_circle,
              size: 50, color: Colors.red),
          Text(
              "Connection timed out. Please check internet connection or proxy server configurations.",
              textAlign: TextAlign.center),
          true,
          Icon(
            CupertinoIcons.checkmark_alt,
            size: 25,
            color: Colors.greenAccent,
          ),
          'Okay',
          () {});
    } on HttpException {
      customModal(
          context,
          Icon(CupertinoIcons.exclamationmark_circle,
              size: 50, color: Colors.red),
          Text("An HTTP error eccured. Please try again later.",
              textAlign: TextAlign.center),
          true,
          Icon(
            CupertinoIcons.checkmark_alt,
            size: 25,
            color: Colors.greenAccent,
          ),
          'Okay',
          () {});
    } on FormatException {
      customModal(
          context,
          Icon(CupertinoIcons.exclamationmark_circle,
              size: 50, color: Colors.red),
          Text("Format exception error occured. Please try again later.",
              textAlign: TextAlign.center),
          true,
          Icon(
            CupertinoIcons.checkmark_alt,
            size: 25,
            color: Colors.greenAccent,
          ),
          'Okay',
          () {});
    }
  }

  Future getTranHead(BuildContext context) async {
    try {
      var url = Uri.parse(UrlAddress.url + '/getalltranhead');
      final response = await retry(() =>
          http.post(url, headers: {"Accept": "Application/json"}, body: {}));
      if (response.statusCode == 200) {
        var convertedDatatoJson = jsonDecode(decrypt(response.body));
        return convertedDatatoJson;
      } else if (response.statusCode >= 400 || response.statusCode <= 499) {
        customModal(
            context,
            Icon(CupertinoIcons.exclamationmark_circle,
                size: 50, color: Colors.red),
            Text(
                "Error: ${response.statusCode}. Your client has issued a malformed or illegal request.",
                textAlign: TextAlign.center),
            true,
            Icon(
              CupertinoIcons.checkmark_alt,
              size: 25,
              color: Colors.greenAccent,
            ),
            '',
            () {});
      } else if (response.statusCode >= 500 || response.statusCode <= 599) {
        customModal(
            context,
            Icon(CupertinoIcons.exclamationmark_circle,
                size: 50, color: Colors.red),
            Text("Error: ${response.statusCode}. Internal server error.",
                textAlign: TextAlign.center),
            true,
            Icon(
              CupertinoIcons.checkmark_alt,
              size: 25,
              color: Colors.greenAccent,
            ),
            '',
            () {});
      }
    } on TimeoutException {
      customModal(
          context,
          Icon(CupertinoIcons.exclamationmark_circle,
              size: 50, color: Colors.red),
          Text(
              "Connection timed out. Please check internet connection or proxy server configurations.",
              textAlign: TextAlign.center),
          true,
          Icon(
            CupertinoIcons.checkmark_alt,
            size: 25,
            color: Colors.greenAccent,
          ),
          'Okay',
          () {});
    } on SocketException {
      customModal(
          context,
          Icon(CupertinoIcons.exclamationmark_circle,
              size: 50, color: Colors.red),
          Text(
              "Connection timed out. Please check internet connection or proxy server configurations.",
              textAlign: TextAlign.center),
          true,
          Icon(
            CupertinoIcons.checkmark_alt,
            size: 25,
            color: Colors.greenAccent,
          ),
          'Okay',
          () {});
    } on HttpException {
      customModal(
          context,
          Icon(CupertinoIcons.exclamationmark_circle,
              size: 50, color: Colors.red),
          Text("An HTTP error eccured. Please try again later.",
              textAlign: TextAlign.center),
          true,
          Icon(
            CupertinoIcons.checkmark_alt,
            size: 25,
            color: Colors.greenAccent,
          ),
          'Okay',
          () {});
    } on FormatException {
      customModal(
          context,
          Icon(CupertinoIcons.exclamationmark_circle,
              size: 50, color: Colors.red),
          Text("Format exception error occured. Please try again later.",
              textAlign: TextAlign.center),
          true,
          Icon(
            CupertinoIcons.checkmark_alt,
            size: 25,
            color: Colors.greenAccent,
          ),
          'Okay',
          () {});
    }
  }

  Future getTranLine(BuildContext context) async {
    try {
      var url = Uri.parse(UrlAddress.url + '/getalltranline');
      final response = await retry(() =>
          http.post(url, headers: {"Accept": "Application/json"}, body: {}));
      if (response.statusCode == 200) {
        var convertedDatatoJson = jsonDecode(decrypt(response.body));
        return convertedDatatoJson;
      } else if (response.statusCode >= 400 || response.statusCode <= 499) {
        customModal(
            context,
            Icon(CupertinoIcons.exclamationmark_circle,
                size: 50, color: Colors.red),
            Text(
                "Error: ${response.statusCode}. Your client has issued a malformed or illegal request.",
                textAlign: TextAlign.center),
            true,
            Icon(
              CupertinoIcons.checkmark_alt,
              size: 25,
              color: Colors.greenAccent,
            ),
            '',
            () {});
      } else if (response.statusCode >= 500 || response.statusCode <= 599) {
        customModal(
            context,
            Icon(CupertinoIcons.exclamationmark_circle,
                size: 50, color: Colors.red),
            Text("Error: ${response.statusCode}. Internal server error.",
                textAlign: TextAlign.center),
            true,
            Icon(
              CupertinoIcons.checkmark_alt,
              size: 25,
              color: Colors.greenAccent,
            ),
            '',
            () {});
      }
    } on TimeoutException {
      customModal(
          context,
          Icon(CupertinoIcons.exclamationmark_circle,
              size: 50, color: Colors.red),
          Text(
              "Connection timed out. Please check internet connection or proxy server configurations.",
              textAlign: TextAlign.center),
          true,
          Icon(
            CupertinoIcons.checkmark_alt,
            size: 25,
            color: Colors.greenAccent,
          ),
          'Okay',
          () {});
    } on SocketException {
      customModal(
          context,
          Icon(CupertinoIcons.exclamationmark_circle,
              size: 50, color: Colors.red),
          Text(
              "Connection timed out. Please check internet connection or proxy server configurations.",
              textAlign: TextAlign.center),
          true,
          Icon(
            CupertinoIcons.checkmark_alt,
            size: 25,
            color: Colors.greenAccent,
          ),
          'Okay',
          () {});
    } on HttpException {
      customModal(
          context,
          Icon(CupertinoIcons.exclamationmark_circle,
              size: 50, color: Colors.red),
          Text("An HTTP error eccured. Please try again later.",
              textAlign: TextAlign.center),
          true,
          Icon(
            CupertinoIcons.checkmark_alt,
            size: 25,
            color: Colors.greenAccent,
          ),
          'Okay',
          () {});
    } on FormatException {
      customModal(
          context,
          Icon(CupertinoIcons.exclamationmark_circle,
              size: 50, color: Colors.red),
          Text("Format exception error occured. Please try again later.",
              textAlign: TextAlign.center),
          true,
          Icon(
            CupertinoIcons.checkmark_alt,
            size: 25,
            color: Colors.greenAccent,
          ),
          'Okay',
          () {});
    }
  }

  Future getUnservedList(BuildContext context) async {
    try {
      var url = Uri.parse(UrlAddress.url + '/getunservedlist');
      final response = await retry(() =>
          http.post(url, headers: {"Accept": "Application/json"}, body: {}));
      if (response.statusCode == 200) {
        var convertedDatatoJson = jsonDecode(decrypt(response.body));
        return convertedDatatoJson;
      } else if (response.statusCode >= 400 || response.statusCode <= 499) {
        customModal(
            context,
            Icon(CupertinoIcons.exclamationmark_circle,
                size: 50, color: Colors.red),
            Text(
                "Error: ${response.statusCode}. Your client has issued a malformed or illegal request.",
                textAlign: TextAlign.center),
            true,
            Icon(
              CupertinoIcons.checkmark_alt,
              size: 25,
              color: Colors.greenAccent,
            ),
            '',
            () {});
      } else if (response.statusCode >= 500 || response.statusCode <= 599) {
        customModal(
            context,
            Icon(CupertinoIcons.exclamationmark_circle,
                size: 50, color: Colors.red),
            Text("Error: ${response.statusCode}. Internal server error.",
                textAlign: TextAlign.center),
            true,
            Icon(
              CupertinoIcons.checkmark_alt,
              size: 25,
              color: Colors.greenAccent,
            ),
            '',
            () {});
      }
    } on TimeoutException {
      customModal(
          context,
          Icon(CupertinoIcons.exclamationmark_circle,
              size: 50, color: Colors.red),
          Text(
              "Connection timed out. Please check internet connection or proxy server configurations.",
              textAlign: TextAlign.center),
          true,
          Icon(
            CupertinoIcons.checkmark_alt,
            size: 25,
            color: Colors.greenAccent,
          ),
          'Okay',
          () {});
    } on SocketException {
      customModal(
          context,
          Icon(CupertinoIcons.exclamationmark_circle,
              size: 50, color: Colors.red),
          Text(
              "Connection timed out. Please check internet connection or proxy server configurations.",
              textAlign: TextAlign.center),
          true,
          Icon(
            CupertinoIcons.checkmark_alt,
            size: 25,
            color: Colors.greenAccent,
          ),
          'Okay',
          () {});
    } on HttpException {
      customModal(
          context,
          Icon(CupertinoIcons.exclamationmark_circle,
              size: 50, color: Colors.red),
          Text("An HTTP error eccured. Please try again later.",
              textAlign: TextAlign.center),
          true,
          Icon(
            CupertinoIcons.checkmark_alt,
            size: 25,
            color: Colors.greenAccent,
          ),
          'Okay',
          () {});
    } on FormatException {
      customModal(
          context,
          Icon(CupertinoIcons.exclamationmark_circle,
              size: 50, color: Colors.red),
          Text("Format exception error occured. Please try again later.",
              textAlign: TextAlign.center),
          true,
          Icon(
            CupertinoIcons.checkmark_alt,
            size: 25,
            color: Colors.greenAccent,
          ),
          'Okay',
          () {});
    }
  }

  Future getReturnedTranList(BuildContext context) async {
    try {
      var url = Uri.parse(UrlAddress.url + '/getreturnedlist');
      final response = await retry(() =>
          http.post(url, headers: {"Accept": "Application/json"}, body: {}));
      if (response.statusCode == 200) {
        var convertedDatatoJson = jsonDecode(decrypt(response.body));
        return convertedDatatoJson;
      } else if (response.statusCode >= 400 || response.statusCode <= 499) {
        customModal(
            context,
            Icon(CupertinoIcons.exclamationmark_circle,
                size: 50, color: Colors.red),
            Text(
                "Error: ${response.statusCode}. Your client has issued a malformed or illegal request.",
                textAlign: TextAlign.center),
            true,
            Icon(
              CupertinoIcons.checkmark_alt,
              size: 25,
              color: Colors.greenAccent,
            ),
            '',
            () {});
      } else if (response.statusCode >= 500 || response.statusCode <= 599) {
        customModal(
            context,
            Icon(CupertinoIcons.exclamationmark_circle,
                size: 50, color: Colors.red),
            Text("Error: ${response.statusCode}. Internal server error.",
                textAlign: TextAlign.center),
            true,
            Icon(
              CupertinoIcons.checkmark_alt,
              size: 25,
              color: Colors.greenAccent,
            ),
            '',
            () {});
      }
    } on TimeoutException {
      customModal(
          context,
          Icon(CupertinoIcons.exclamationmark_circle,
              size: 50, color: Colors.red),
          Text(
              "Connection timed out. Please check internet connection or proxy server configurations.",
              textAlign: TextAlign.center),
          true,
          Icon(
            CupertinoIcons.checkmark_alt,
            size: 25,
            color: Colors.greenAccent,
          ),
          'Okay',
          () {});
    } on SocketException {
      customModal(
          context,
          Icon(CupertinoIcons.exclamationmark_circle,
              size: 50, color: Colors.red),
          Text(
              "Connection timed out. Please check internet connection or proxy server configurations.",
              textAlign: TextAlign.center),
          true,
          Icon(
            CupertinoIcons.checkmark_alt,
            size: 25,
            color: Colors.greenAccent,
          ),
          'Okay',
          () {});
    } on HttpException {
      customModal(
          context,
          Icon(CupertinoIcons.exclamationmark_circle,
              size: 50, color: Colors.red),
          Text("An HTTP error eccured. Please try again later.",
              textAlign: TextAlign.center),
          true,
          Icon(
            CupertinoIcons.checkmark_alt,
            size: 25,
            color: Colors.greenAccent,
          ),
          'Okay',
          () {});
    } on FormatException {
      customModal(
          context,
          Icon(CupertinoIcons.exclamationmark_circle,
              size: 50, color: Colors.red),
          Text("Format exception error occured. Please try again later.",
              textAlign: TextAlign.center),
          true,
          Icon(
            CupertinoIcons.checkmark_alt,
            size: 25,
            color: Colors.greenAccent,
          ),
          'Okay',
          () {});
    }
  }

  Future saveTransactions(
      BuildContext context,
      String userId,
      String date,
      String custId,
      String storeName,
      String payment,
      String itmcount,
      String totamt,
      String stat,
      String signature,
      String smStat,
      String hepeStat,
      List line) async {
    try {
      var url = Uri.parse(UrlAddress.url + '/addtransactions');
      final response = await retry(() => http.post(url, headers: {
            "Accept": "Application/json"
          }, body: {
            'sm_code': encrypt(userId),
            'date_req': encrypt(date),
            'account_code': encrypt(custId),
            'store_name': encrypt(storeName),
            'p_meth': encrypt(payment),
            'itm_count': encrypt(itmcount),
            'tot_amt': encrypt(totamt),
            'tran_stat': encrypt(stat),
            'auth_signature': encrypt(signature),
            'sm_upload': encrypt(smStat),
            'hepe_upload': encrypt(hepeStat),
            'line': jsonEncode(line),
          }));
      if (response.statusCode == 200) {
        var convertedDatatoJson = jsonDecode(response.body);
        return convertedDatatoJson;
      } else if (response.statusCode >= 400 || response.statusCode <= 499) {
        customModal(
            context,
            Icon(CupertinoIcons.exclamationmark_circle,
                size: 50, color: Colors.red),
            Text(
                "Error: ${response.statusCode}. Your client has issued a malformed or illegal request.",
                textAlign: TextAlign.center),
            true,
            Icon(
              CupertinoIcons.checkmark_alt,
              size: 25,
              color: Colors.greenAccent,
            ),
            '',
            () {});
      } else if (response.statusCode >= 500 || response.statusCode <= 599) {
        customModal(
            context,
            Icon(CupertinoIcons.exclamationmark_circle,
                size: 50, color: Colors.red),
            Text("Error: ${response.statusCode}. Internal server error.",
                textAlign: TextAlign.center),
            true,
            Icon(
              CupertinoIcons.checkmark_alt,
              size: 25,
              color: Colors.greenAccent,
            ),
            '',
            () {});
      }
    } on TimeoutException {
      customModal(
          context,
          Icon(CupertinoIcons.exclamationmark_circle,
              size: 50, color: Colors.red),
          Text(
              "Connection timed out. Please check internet connection or proxy server configurations.",
              textAlign: TextAlign.center),
          true,
          Icon(
            CupertinoIcons.checkmark_alt,
            size: 25,
            color: Colors.greenAccent,
          ),
          'Okay',
          () {});
    } on SocketException {
      customModal(
          context,
          Icon(CupertinoIcons.exclamationmark_circle,
              size: 50, color: Colors.red),
          Text(
              "Connection timed out. Please check internet connection or proxy server configurations.",
              textAlign: TextAlign.center),
          true,
          Icon(
            CupertinoIcons.checkmark_alt,
            size: 25,
            color: Colors.greenAccent,
          ),
          'Okay',
          () {});
    } on HttpException {
      customModal(
          context,
          Icon(CupertinoIcons.exclamationmark_circle,
              size: 50, color: Colors.red),
          Text("An HTTP error eccured. Please try again later.",
              textAlign: TextAlign.center),
          true,
          Icon(
            CupertinoIcons.checkmark_alt,
            size: 25,
            color: Colors.greenAccent,
          ),
          'Okay',
          () {});
    } on FormatException {
      customModal(
          context,
          Icon(CupertinoIcons.exclamationmark_circle,
              size: 50, color: Colors.red),
          Text("Format exception error occured. Please try again later.",
              textAlign: TextAlign.center),
          true,
          Icon(
            CupertinoIcons.checkmark_alt,
            size: 25,
            color: Colors.greenAccent,
          ),
          'Okay',
          () {});
    }
  }

  // Future saveTransactionHead(
  //     String userId,
  //     String date,
  //     String custId,
  //     String storeName,
  //     String payment,
  //     String itmcount,
  //     String totamt,
  //     String stat,
  //     String signature,
  //     String smStat,
  //     String hepeStat) async {
  //   // String url = UrlAddress.url + '/addtranhead';
  //   var url = Uri.parse(UrlAddress.url + '/addtranhead');
  //   final response = await retry(() => http.post(url, headers: {
  //         "Accept": "Application/json"
  //       }, body: {
  //         'sm_code': encrypt(userId),
  //         'date_req': encrypt(date),
  //         'account_code': encrypt(custId),
  //         'store_name': encrypt(storeName),
  //         'p_meth': encrypt(payment),
  //         'itm_count': encrypt(itmcount),
  //         'tot_amt': encrypt(totamt),
  //         'tran_stat': encrypt(stat),
  //         'auth_signature': encrypt(signature),
  //         'sm_upload': encrypt(smStat),
  //         'hepe_upload': encrypt(hepeStat),
  //       }));
  //   var convertedDatatoJson = jsonDecode(response.body);
  //   return convertedDatatoJson;
  // }

  // Future saveTransactionLine(
  //     String tranNo,
  //     String itmcode,
  //     String desc,
  //     String qty,
  //     String uom,
  //     String amt,
  //     String totamt,
  //     String categ,
  //     String code,
  //     String date) async {
  //   // String url = UrlAddress.url + '/addtranline';
  //   var url = Uri.parse(UrlAddress.url + '/addtranline');
  //   final response = await retry(() => http.post(url, headers: {
  //         "Accept": "Application/json"
  //       }, body: {
  //         'tran_no': encrypt(tranNo),
  //         'itm_code': encrypt(itmcode),
  //         'item_desc': encrypt(desc),
  //         'req_qty': encrypt(qty),
  //         'uom': encrypt(uom),
  //         'amt': encrypt(amt),
  //         'tot_amt': encrypt(totamt),
  //         'itm_cat': encrypt(categ),
  //         'account_code': encrypt(code),
  //         'date_req': encrypt(date),
  //       }));
  //   var convertedDatatoJson = jsonDecode(response.body);
  //   return convertedDatatoJson;
  // }

  Future checkStat() async {
    try {
      // String url = UrlAddress.url + '/checkstat';
      var url = Uri.parse(UrlAddress.url + '/checkstat');
      final response = await http
          .post(url, headers: {"Accept": "Application/json"}, body: {});
      var convertedDatatoJson = jsonDecode(response.body);
      return convertedDatatoJson;
    } on SocketException {
      return 'ERROR1';
    } on HttpException {
      return 'ERROR2';
    } on FormatException {
      return 'ERROR3';
    }
  }

  /////////
  /////////
  /////////
  //////// HEPE DE VIAJE CODE
  /////////
  /////////
  /////////

  Future getApprovedOrders() async {
    var client = await db;
    return client.rawQuery(
        'SELECT * FROM tb_tran_head WHERE tran_stat ="Approved" AND hepe_upload = "FALSE"  ORDER BY store_name ASC',
        null);
  }

  Future getPendingOrders() async {
    var client = await db;
    return client.rawQuery(
        'SELECT * FROM tb_tran_head WHERE tran_stat ="Pending" ORDER BY store_name ASC',
        null);
  }

  Future checkDiscounted(id) async {
    var client = await db;
    List<Map> res = await client.rawQuery(
        'SELECT * FROM tbl_discounts WHERE cus_id ="$id"', null);
    if (res.isNotEmpty) {
      return "TRUE";
    } else {
      return "FALSE";
    }
  }

  Future getCustInfo(code) async {
    var client = await db;
    return client.rawQuery(
        'SELECT address1,address2,address3,cus_mobile_number,customer_id FROM customer_master_files WHERE account_code ="$code"',
        null);
  }

  Future getOrders(tran) async {
    var client = await db;
    return client.rawQuery(
        'SELECT *,(req_qty - del_qty) as outstock,(del_qty) as temp_qty FROM tb_tran_line WHERE tran_no ="$tran" ORDER BY item_desc ASC',
        null);
  }

  Future getAll(tran) async {
    print(tran);
    var client = await db;
    return client.rawQuery('SELECT * FROM tb_tran_line', null);
  }

  Future addtoUnserved(tranNo, itemCode, itemDesc, itemUom, itemAmt, itemQty,
      totAmt, itemCat) async {
    int fqty = 0;
    double ftotal = 0.00;
    String itmStat = "Returned";
    String date = DateFormat("yyyy-MM-dd HH:mm:ss").format(new DateTime.now());
    var client = await db;

    List<Map> res = await client.rawQuery(
        'SELECT * FROM tb_unserved_items WHERE tran_no ="$tranNo" AND itm_code ="$itemCode" AND  uom = "$itemUom" AND itm_stat = "$itmStat"',
        null);
    if (res.isEmpty) {
      return client.insert('tb_unserved_items', {
        'tran_no': tranNo,
        'date': date,
        'itm_code': itemCode,
        'item_desc': itemDesc,
        'qty': itemQty,
        'uom': itemUom,
        'amt': itemAmt,
        'tot_amt': totAmt,
        'itm_cat': itemCat,
        'itm_stat': itmStat,
      });
    } else {
      res.forEach((element) {
        fqty = int.parse(element['qty']);
        ftotal = double.parse(element['tot_amt']);
      });
      return client.update(
          'tb_unserved_items',
          {
            'qty': (fqty + int.parse(itemQty)).toString(),
            'tot_amt': (ftotal + double.parse(totAmt)).toString()
          },
          where: 'tran_no = ? AND itm_stat = ? AND itm_code = ? AND uom = ?',
          whereArgs: [tranNo, itmStat, itemCode, itemUom]);
    }
  }

  Future minusQtytoLine(tranNo, itemCode, itemUom, itemQty) async {
    double totDiscAmt = 0;
    double totAmt = 0.00;
    var client = await db;
    var x;

    List<Map> res = await client.rawQuery(
        'SELECT * FROM tb_tran_line WHERE tran_no ="$tranNo" AND itm_code ="$itemCode" AND  uom = "$itemUom"',
        null);
    if (res.isNotEmpty) {
      res.forEach((element) {
        totAmt =
            double.parse(element['tot_amt']) - double.parse(element['amt']);
        totDiscAmt = (double.parse(element['discounted_amount'])) -
            (double.parse(element['discounted_amount']) /
                double.parse(element['del_qty']));
        // return client.update(
        //     'tb_tran_line',
        //     {
        //       'del_qty': itemQty,
        //       'tot_amt': totAmt,
        //       'discounted_amount': totDiscAmt,
        //     },
        //     where: 'tran_no = ?  AND itm_code = ? AND uom = ?',
        //     whereArgs: [tranNo, itemCode, itemUom]);
        x = client.update(
            'tb_tran_line',
            {
              'del_qty': itemQty,
              'tot_amt': totAmt,
              'discounted_amount': totDiscAmt,
            },
            where: 'tran_no = ?  AND itm_code = ? AND uom = ?',
            whereArgs: [tranNo, itemCode, itemUom]);
        return x;
      });
    }
  }

  Future addQtytoLine(tranNo, itemCode, itemDesc, itemUom, itemAmt, itemQty,
      totAmt, itemCat) async {
    String qty = '';
    double totDiscAmt = 0;
    double totAmt = 0.00;
    var client = await db;
    var x;

    List<Map> res = await client.rawQuery(
        'SELECT * FROM tb_tran_line WHERE tran_no ="$tranNo" AND itm_code ="$itemCode" AND  uom = "$itemUom"',
        null);
    if (res.isNotEmpty) {
      res.forEach((element) {
        qty = (int.parse(element['del_qty']) + int.parse(itemQty)).toString();
        totAmt =
            double.parse(element['tot_amt']) + double.parse(element['amt']);
        totDiscAmt = (double.parse(element['discounted_amount'])) +
            (double.parse(element['discounted_amount']) /
                double.parse(element['del_qty']));

        // return client.update(
        //     'tb_tran_line',
        //     {
        //       'del_qty': qty,
        //       'tot_amt': totAmt,
        //       'discounted_amount': totDiscAmt,
        //     },
        //     where: 'tran_no = ?  AND itm_code = ? AND uom = ?',
        //     whereArgs: [tranNo, itemCode, itemUom]);
        x = client.update(
            'tb_tran_line',
            {
              'del_qty': qty,
              'tot_amt': totAmt,
              'discounted_amount': totDiscAmt,
            },
            where: 'tran_no = ?  AND itm_code = ? AND uom = ?',
            whereArgs: [tranNo, itemCode, itemUom]);
        return x;
      });
    }
  }

  Future deleteQtytoLog(tranNo, itemCode, itemUom, itemQty) async {
    String qty = '';
    var x;
    var client = await db;

    List<Map> res = await client.rawQuery(
        'SELECT * FROM tb_unserved_items WHERE tran_no ="$tranNo" AND itm_code ="$itemCode" AND  uom = "$itemUom"',
        null);
    if (res.isNotEmpty) {
      res.forEach((element) {
        if (int.parse(element['qty']) - int.parse(itemQty) > 0) {
          qty = (int.parse(element['qty']) - int.parse(itemQty)).toString();

          // return client.update(
          //     'tb_unserved_items',
          //     {
          //       'qty': qty,
          //     },
          //     where: 'tran_no = ? AND itm_code = ? AND uom = ?',
          //     whereArgs: [tranNo, itemCode, itemUom]);
          x = client.update(
              'tb_unserved_items',
              {
                'qty': qty,
              },
              where: 'tran_no = ? AND itm_code = ? AND uom = ?',
              whereArgs: [tranNo, itemCode, itemUom]);
          return x;
        } else {
          // return client.rawQuery(
          //     'DELETE FROM tb_unserved_items WHERE tran_no ="$tranNo" AND itm_code ="$itemCode" AND  uom = "$itemUom"',
          //     null);
          x = client.rawQuery(
              'DELETE FROM tb_unserved_items WHERE tran_no ="$tranNo" AND itm_code ="$itemCode" AND  uom = "$itemUom"',
              null);
          return x;
        }
      });
    }
  }

  Future addtoReturnLine(
      tran, itmcode, desc, uom, amt, qty, itmtotal, categ) async {
    String stat = 'Returned';
    var client = await db;
    return client.insert('tb_unserved_items', {
      'tran_no': tran,
      'itm_code': itmcode,
      'item_desc': desc,
      'uom': uom,
      'amt': amt,
      'qty': qty,
      'tot_amt': itmtotal,
      'itm_cat': categ,
      'itm_stat': stat,
    });
  }

  Future addtoReturnedTran(tranNo, accountCode, storeName, itemCount, totAmt,
      hepeCode, reason, sign) async {
    String stat = 'FALSE';
    String date = DateFormat("yyyy-MM-dd HH:mm:ss").format(new DateTime.now());
    var client = await db;

    return client.insert('tb_returned_tran', {
      'tran_no': tranNo,
      'date': date,
      'account_code': accountCode,
      'store_name': storeName,
      'itm_count': itemCount,
      'tot_amt': totAmt,
      'hepe_code': hepeCode,
      'reason': reason,
      'signature': sign,
      'uploaded': stat
    });
  }

  Future updateReturnStatus(tranNo, hepeCode, status, amount, sign) async {
    var client = await db;
    String date = DateFormat("yyyy-MM-dd HH:mm:ss").format(new DateTime.now());

    return client.update(
        'tb_tran_head',
        {
          'tran_stat': status,
          'hepe_code': hepeCode,
          'tot_del_amt': amount,
          'date_del': date,
          'signature': sign,
        },
        where: 'tran_no = ?',
        whereArgs: [tranNo]);
  }

  Future getStatus(
      tranNo, status, amt, itmdelcount, hepecode, type, sign) async {
    var client = await db;
    String date = DateFormat("yyyy-MM-dd HH:mm:ss").format(new DateTime.now());

    return client.update(
        'tb_tran_head',
        {
          'tran_stat': status,
          'tot_del_amt': amt,
          'date_del': date,
          'itm_del_count': itmdelcount,
          'hepe_code': hepecode,
          'pmeth_type': type,
          'signature': sign,
        },
        where: 'tran_no = ?',
        whereArgs: [tranNo]);
  }

  Future updateLineStatus(tranNo, status, date) async {
    var client = await db;

    return client.update(
        'tb_tran_line',
        {
          'itm_stat': status,
          'date_del': date,
        },
        where: 'tran_no = ?',
        whereArgs: [tranNo]);
  }

  Future addCheque(
      tranNo,
      accountcode,
      smcode,
      hepecode,
      datetime,
      payeename,
      payorname,
      bankname,
      chequeno,
      branchno,
      accountno,
      chequedate,
      amount,
      status,
      img) async {
    var client = await db;
    String date = DateFormat("yyyy-MM-dd HH:mm:ss").format(new DateTime.now());
    return client.insert('tb_cheque_data', {
      'tran_no': tranNo,
      'account_code': accountcode,
      'sm_code': smcode,
      'hepe_code': hepecode,
      'datetime': date,
      'payee_name': payeename,
      'payor_name': payorname,
      'bank_name': bankname,
      'cheque_no': chequeno,
      'branch_code': branchno,
      'account_no': accountno,
      'cheque_date': chequedate,
      'amount': amount,
      'status': status,
      'image': img,
    });
  }

  Future getBankList() async {
    var client = await db;
    return client.rawQuery('SELECT * FROM tb_bank_list ', null);
  }

  Future checkChequeNo(chequeNum, smCode) async {
    var client = await db;
    List<Map> res = await client.rawQuery(
        'SELECT * FROM tb_cheque_data WHERE cheque_no ="$chequeNum" AND sm_code!="$smCode"',
        null);
    if (res.isNotEmpty) {
      return "Already Used";
    } else {
      return "No Transaction";
    }
  }

  Future getChequeData(tranNo) async {
    var client = await db;
    return client.rawQuery(
        'SELECT * FROM tb_cheque_data WHERE tran_no ="$tranNo"', null);
  }

  Future getUnservedOrders(tranNo) async {
    String stat = 'Unserved';
    var client = await db;
    return client.rawQuery(
        'SELECT *,tb_tran_head.tran_stat FROM tb_unserved_items INNER JOIN tb_tran_head on tb_tran_head.tran_no = tb_unserved_items.tran_no WHERE tb_unserved_items.tran_no ="$tranNo" AND tb_unserved_items.itm_stat = "$stat"  ORDER BY doc_no ASC',
        null);
  }

  Future getReturnedOrders(tranNo) async {
    String stat = 'Returned';
    var client = await db;
    return client.rawQuery(
        'SELECT *,tb_tran_head.tran_stat FROM tb_unserved_items INNER JOIN tb_tran_head on tb_tran_head.tran_no = tb_unserved_items.tran_no WHERE tb_unserved_items.tran_no ="$tranNo" AND tb_unserved_items.itm_stat = "$stat"  ORDER BY doc_no ASC',
        null);
  }

  Future getDeliveredOrders(tranNo) async {
    String stat = 'Delivered';
    var client = await db;
    return client.rawQuery(
        'SELECT * FROM tb_tran_line  WHERE tran_no ="$tranNo" AND itm_stat = "$stat" ORDER BY doc_no ASC',
        null);
  }

  Future checkChanges(tranNo) async {
    String stat = 'Returned';
    var client = await db;
    return client.rawQuery(
        'SELECT * FROM tb_unserved_items WHERE tb_unserved_items.tran_no ="$tranNo" AND tb_unserved_items.itm_stat = "$stat"  ORDER BY doc_no ASC',
        null);
  }

  Future setChequeData(
      String tranNo,
      String accountCode,
      String smCode,
      String hepeCode,
      String datetime,
      String payeeName,
      String payorName,
      String bankName,
      String chequeNo,
      String branchCode,
      String accountNo,
      String chequeDate,
      String amount,
      String status,
      String img) async {
    // String url = UrlAddress.url + '/addcheque';
    var url = Uri.parse(UrlAddress.url + '/addcheque');
    final response = await retry(() => http.post(url, headers: {
          "Accept": "Application/json"
        }, body: {
          'tran_no': tranNo,
          'account_code': accountCode,
          'sm_code': smCode,
          'hepe_code': hepeCode,
          'datetime': datetime,
          'payee_name': payeeName,
          'payor_name': payorName,
          'bank_name': bankName,
          'cheque_no': chequeNo,
          'branch_code': branchCode,
          'account_no': accountNo,
          'cheque_date': chequeDate,
          'amount': amount,
          'status': status,
          'image': img,
        }));
    var convertedDatatoJson = jsonDecode(response.body);
    return convertedDatatoJson;
  }

  Future viewStatus() async {
    var client = await db;
    return client.rawQuery('SELECT * FROM tb_returned_tran', null);
    // return client.rawQuery(
    //     'SELECT * FROM tb_tran_head WHERE tran_stat ="Delivered" OR tran_stat="Returned"',
    //     null);
  }

  Future getRemovedOrders() async {
    var client = await db;
    return client.rawQuery('SELECT * FROM tb_unserved_items', null);
    // return client.rawQuery(
    //     'SELECT * FROM tb_tran_head WHERE tran_stat ="Delivered" OR tran_stat="Returned"',
    //     null);
  }

  Future ofFetchSampleLine(tranNo) async {
    var client = await db;
    return client.rawQuery(
        'SELECT * FROM tb_tran_line WHERE tran_no ="$tranNo"', null);
  }

  Future ofFetchSampleTable() async {
    var client = await db;
    return client.rawQuery(
        'SELECT tran_no FROM tb_tran_line WHERE doc_no!=" "', null);
  }

  //////
  ///HEPE API
  ///
  // Future oldupdateTranStat(
  //     String tranNo,
  //     String status,
  //     String itmdel,
  //     String amt,
  //     String date,
  //     String hepecode,
  //     String type,
  //     String signature) async {
  //   // String url = UrlAddress.url + '/updatetranstat';
  //   var url = Uri.parse(UrlAddress.url + '/updatetranstat');
  //   final response = await retry(() => http.post(url, headers: {
  //         "Accept": "Application/json"
  //       }, body: {
  //         'tran_no': encrypt(tranNo),
  //         'tran_stat': encrypt(status),
  //         'itm_del_count': encrypt(itmdel),
  //         'tot_del_amt': encrypt(amt),
  //         'date_del': encrypt(date),
  //         'hepe_code': encrypt(hepecode),
  //         'pmeth_type': encrypt(type),
  //         'signature': encrypt(signature),
  //       }));
  //   var convertedDatatoJson = jsonDecode(response.body);
  //   return convertedDatatoJson;
  // }

  Future updateDeliveredTranStat(
      BuildContext context,
      String tranNo,
      String status,
      String itmdel,
      String amt,
      String date,
      String hepecode,
      String type,
      String signature,
      List tranLine,
      List unsLine) async {
    try {
      var url = Uri.parse(UrlAddress.url + '/updatedeliveredtranstatwithline');
      final response = await retry(() => http.post(url, headers: {
            "Accept": "Application/json"
          }, body: {
            'tran_no': encrypt(tranNo),
            'tran_stat': encrypt(status),
            'itm_del_count': encrypt(itmdel),
            'tot_del_amt': encrypt(amt),
            'date_del': encrypt(date),
            'hepe_code': encrypt(hepecode),
            'pmeth_type': encrypt(type),
            'signature': encrypt(signature),
            'tranline': jsonEncode(tranLine),
            'unsline': jsonEncode(unsLine),
          }));
      if (response.statusCode == 200) {
        var convertedDatatoJson = jsonDecode(response.body);
        return convertedDatatoJson;
      } else if (response.statusCode >= 400 || response.statusCode <= 499) {
        customModal(
            context,
            Icon(CupertinoIcons.exclamationmark_circle,
                size: 50, color: Colors.red),
            Text(
                "Error: ${response.statusCode}. Your client has issued a malformed or illegal request.",
                textAlign: TextAlign.center),
            true,
            Icon(
              CupertinoIcons.checkmark_alt,
              size: 25,
              color: Colors.greenAccent,
            ),
            '',
            () {});
      } else if (response.statusCode >= 500 || response.statusCode <= 599) {
        customModal(
            context,
            Icon(CupertinoIcons.exclamationmark_circle,
                size: 50, color: Colors.red),
            Text("Error: ${response.statusCode}. Internal server error.",
                textAlign: TextAlign.center),
            true,
            Icon(
              CupertinoIcons.checkmark_alt,
              size: 25,
              color: Colors.greenAccent,
            ),
            '',
            () {});
      }
    } on TimeoutException {
      customModal(
          context,
          Icon(CupertinoIcons.exclamationmark_circle,
              size: 50, color: Colors.red),
          Text(
              "Connection timed out. Please check internet connection or proxy server configurations.",
              textAlign: TextAlign.center),
          true,
          Icon(
            CupertinoIcons.checkmark_alt,
            size: 25,
            color: Colors.greenAccent,
          ),
          'Okay',
          () {});
    } on SocketException {
      customModal(
          context,
          Icon(CupertinoIcons.exclamationmark_circle,
              size: 50, color: Colors.red),
          Text(
              "Connection timed out. Please check internet connection or proxy server configurations.",
              textAlign: TextAlign.center),
          true,
          Icon(
            CupertinoIcons.checkmark_alt,
            size: 25,
            color: Colors.greenAccent,
          ),
          'Okay',
          () {});
    } on HttpException {
      customModal(
          context,
          Icon(CupertinoIcons.exclamationmark_circle,
              size: 50, color: Colors.red),
          Text("An HTTP error eccured. Please try again later.",
              textAlign: TextAlign.center),
          true,
          Icon(
            CupertinoIcons.checkmark_alt,
            size: 25,
            color: Colors.greenAccent,
          ),
          'Okay',
          () {});
    } on FormatException {
      customModal(
          context,
          Icon(CupertinoIcons.exclamationmark_circle,
              size: 50, color: Colors.red),
          Text("Format exception error occured. Please try again later.",
              textAlign: TextAlign.center),
          true,
          Icon(
            CupertinoIcons.checkmark_alt,
            size: 25,
            color: Colors.greenAccent,
          ),
          'Okay',
          () {});
    }
  }

  Future updateReturnedTranStat(
      BuildContext context,
      String tranNo,
      String status,
      // String itmdel,
      String amt,
      String date,
      String hepecode,
      // String type,
      String signature,
      List rettran,
      List retline) async {
    try {
      var url = Uri.parse(UrlAddress.url + '/updatereturnedtranstatwithline');
      final response = await retry(() => http.post(url, headers: {
            "Accept": "Application/json"
          }, body: {
            'tran_no': encrypt(tranNo),
            'tran_stat': encrypt(status),
            // 'itm_del_count': encrypt(itmdel),
            'tot_del_amt': encrypt(amt),
            'date_del': encrypt(date),
            'hepe_code': encrypt(hepecode),
            // 'pmeth_type': encrypt(type),
            'signature': encrypt(signature),
            'rettran': jsonEncode(rettran),
            'retline': jsonEncode(retline),
          }));
      if (response.statusCode == 200) {
        var convertedDatatoJson = jsonDecode(response.body);
        return convertedDatatoJson;
      } else if (response.statusCode >= 400 || response.statusCode <= 499) {
        customModal(
            context,
            Icon(CupertinoIcons.exclamationmark_circle,
                size: 50, color: Colors.red),
            Text(
                "Error: ${response.statusCode}. Your client has issued a malformed or illegal request.",
                textAlign: TextAlign.center),
            true,
            Icon(
              CupertinoIcons.checkmark_alt,
              size: 25,
              color: Colors.greenAccent,
            ),
            '',
            () {});
      } else if (response.statusCode >= 500 || response.statusCode <= 599) {
        customModal(
            context,
            Icon(CupertinoIcons.exclamationmark_circle,
                size: 50, color: Colors.red),
            Text("Error: ${response.statusCode}. Internal server error.",
                textAlign: TextAlign.center),
            true,
            Icon(
              CupertinoIcons.checkmark_alt,
              size: 25,
              color: Colors.greenAccent,
            ),
            '',
            () {});
      }
    } on TimeoutException {
      customModal(
          context,
          Icon(CupertinoIcons.exclamationmark_circle,
              size: 50, color: Colors.red),
          Text(
              "Connection timed out. Please check internet connection or proxy server configurations.",
              textAlign: TextAlign.center),
          true,
          Icon(
            CupertinoIcons.checkmark_alt,
            size: 25,
            color: Colors.greenAccent,
          ),
          'Okay',
          () {});
    } on SocketException {
      customModal(
          context,
          Icon(CupertinoIcons.exclamationmark_circle,
              size: 50, color: Colors.red),
          Text(
              "Connection timed out. Please check internet connection or proxy server configurations.",
              textAlign: TextAlign.center),
          true,
          Icon(
            CupertinoIcons.checkmark_alt,
            size: 25,
            color: Colors.greenAccent,
          ),
          'Okay',
          () {});
    } on HttpException {
      customModal(
          context,
          Icon(CupertinoIcons.exclamationmark_circle,
              size: 50, color: Colors.red),
          Text("An HTTP error eccured. Please try again later.",
              textAlign: TextAlign.center),
          true,
          Icon(
            CupertinoIcons.checkmark_alt,
            size: 25,
            color: Colors.greenAccent,
          ),
          'Okay',
          () {});
    } on FormatException {
      customModal(
          context,
          Icon(CupertinoIcons.exclamationmark_circle,
              size: 50, color: Colors.red),
          Text("Format exception error occured. Please try again later.",
              textAlign: TextAlign.center),
          true,
          Icon(
            CupertinoIcons.checkmark_alt,
            size: 25,
            color: Colors.greenAccent,
          ),
          'Okay',
          () {});
    }
  }

  // Future updateLineStat(String tranNo, String status, String qty, String totAmt,
  //     String totDiscAmt, String itmcode, String uom, String date) async {
  //   try {
  //     // String url = UrlAddress.url + '/updatelinestat';
  //     var url = Uri.parse(UrlAddress.url + '/updatelinestat');
  //     final response = await http.post(url, headers: {
  //       "Accept": "Application/json"
  //     }, body: {
  //       'tran_no': encrypt(tranNo),
  //       'itm_stat': encrypt(status),
  //       'del_qty': encrypt(qty),
  //       'tot_amt': encrypt(totAmt),
  //       'discounted_amount': encrypt(totDiscAmt),
  //       'itm_code': encrypt(itmcode),
  //       'uom': encrypt(uom),
  //       'date_del': encrypt(date),
  //     });
  //     var convertedDatatoJson = jsonDecode(response.body);
  //     return convertedDatatoJson;
  //   } on SocketException {
  //     return 'ERROR';
  //   } on HttpException {
  //     return 'ERROR';
  //   } on FormatException {
  //     return 'ERROR';
  //   }
  // }

  //FOR ADDING RETURNED TRAN TO SERVER
  // Future setReturnStatus(
  //   String userId,
  //   String date,
  //   String signature,
  //   String accountCode,
  //   String sName,
  //   String itmcount,
  //   String retamt,
  //   String smcode,
  //   String reason,
  // ) async {
  //   // String url = UrlAddress.url + '/setreturnstatus';
  //   var url = Uri.parse(UrlAddress.url + '/setreturnstatus');
  //   final response = await retry(() => http.post(url, headers: {
  //         "Accept": "Application/json"
  //       }, body: {
  //         'tran_no': userId,
  //         'date': date,
  //         'signature': signature,
  //         'account_code': accountCode,
  //         'store_name': sName,
  //         'itm_count': itmcount,
  //         'tot_amt': retamt,
  //         'hepe_code': smcode,
  //         'reason': reason,
  //       }));
  //   var convertedDatatoJson = jsonDecode(response.body);
  //   return convertedDatatoJson;
  // }

  // Future setReturnLineStatus(String tran, String itmcode, String desc,
  //     String uom, String amt, String qty, String itmtotal, String categ) async {
  //   try {
  //     // String url = UrlAddress.url + '/addreturnline';
  //     var url = Uri.parse(UrlAddress.url + '/addreturnline');
  //     final response = await http.post(url, headers: {
  //       "Accept": "Application/json"
  //     }, body: {
  //       'tran_no': tran,
  //       'itm_code': itmcode,
  //       'item_desc': desc,
  //       'uom': uom,
  //       'amt': amt,
  //       'qty': qty,
  //       'tot_amt': itmtotal,
  //       'itm_cat': categ,
  //     });
  //     var convertedDatatoJson = jsonDecode(response.body);
  //     return convertedDatatoJson;
  //   } on SocketException {
  //     return 'ERROR';
  //   } on HttpException {
  //     return 'ERROR';
  //   } on FormatException {
  //     return 'ERROR';
  //   }
  // }

  Future addfav(cusCode, itmCode, uom) async {
    var client = await db;
    return client.insert('tb_favorites', {
      'account_code': cusCode,
      'item_code': itmCode,
      'item_uom': uom,
    });
  }

  Future deleteFav(cusCode, itmCode, uom) async {
    var client = await db;
    return client.rawQuery(
        'DELETE FROM tb_favorites WHERE account_code = "$cusCode" AND item_code= "$itmCode" AND item_uom= "$uom"',
        null);
  }

  Future getFav(code) async {
    var client = await db;
    return client.rawQuery(
        'SELECT *,item_masterfiles.product_name,item_masterfiles.product_family,item_masterfiles.uom,item_masterfiles.list_price_wtax, item_masterfiles.image FROM tb_favorites INNER JOIN item_masterfiles on tb_favorites.item_code = item_masterfiles.itemcode  WHERE tb_favorites.account_code ="$code" AND item_masterfiles.conversion_qty="1"',
        null);
  }

  ////////
  /// HEPE DE VIAJE SALES
  /////////
  ///
  Future getSalesType() async {
    var client = await db;
    return client.rawQuery(
        'SELECT * FROM tb_sales_type WHERE categ ="Sales"', null);
  }

  Future getTotalSalesType() async {
    var client = await db;
    return client.rawQuery(
        'SELECT * FROM tb_sales_type WHERE categ ="Total"', null);
  }

  Future getDailySales(id, type) async {
    String date = DateFormat("yyyy-MM-dd").format(new DateTime.now());
    String stat = 'Delivered';
    var client = await db;

    if (type == "OVERALL") {
      print(date);
      return client.rawQuery(
          'SELECT tran_no,store_name,SUM(tb_tran_head.tot_del_amt) as total FROM tb_tran_head WHERE hepe_code ="$id" AND tran_stat="$stat" AND strftime("%Y-%m-%d", date_del)="$date"',
          null);
    } else {
      return client.rawQuery(
          'SELECT *,SUM(tb_tran_head.tot_del_amt) as total FROM tb_tran_head WHERE hepe_code ="$id" AND tran_stat="$stat" AND pmeth_type="$type" AND (strftime("%y-%m-%d", date_del)="$date")',
          null);
    }
  }

  Future getConsolidatedApprovedRequestHead() async {
    String stat = 'Approved';
    var client = await db;

    return client.rawQuery(
        'SELECT *,SUM(tb_tran_head.tot_amt) as total FROM tb_tran_head WHERE tran_stat="$stat" GROUP BY strftime("%Y-%m-%d", date_req), account_code ORDER BY date_req ASC ',
        null);
  }

  Future getTransactionNoList(code, date) async {
    String stat = 'Delivered';
    var client = await db;

    return client.rawQuery(
        'SELECT tran_no,SUM(amt*del_qty) as total,SUM(discounted_amount) as disc_total FROM tb_tran_line WHERE itm_stat !="$stat" AND account_code ="$code" AND strftime("%Y-%m-%d", date_req)="$date"  GROUP BY tran_no ORDER BY doc_no ASC ',
        null);
  }

  Future getConsolidatedApprovedRequestLine(code, date) async {
    String stat = 'Delivered';
    var client = await db;

    return client.rawQuery(
        'SELECT *,SUM(del_qty) as total_qty FROM tb_tran_line WHERE itm_stat !="$stat" AND account_code ="$code" AND strftime("%Y-%m-%d", date_req)="$date"  GROUP BY itm_code ORDER BY doc_no ASC ',
        null);
  }

  Future getTranperLine(itmcode, code, date) async {
    String stat = 'Delivered';
    var client = await db;

    return client.rawQuery(
        'SELECT * FROM tb_tran_line WHERE itm_stat !="$stat" AND account_code ="$code" AND strftime("%Y-%m-%d", date_req)="$date" AND itm_code="$itmcode"',
        null);
  }

  Future getOrderLimit() async {
    // String url = UrlAddress.url + '/gorderlimit';
    var url = Uri.parse(UrlAddress.url + '/gorderlimit');
    final response =
        await http.post(url, headers: {"Accept": "Application/json"}, body: {});
    var convertedDatatoJson = jsonDecode(response.body);
    return convertedDatatoJson;
  }

  Future loginUser(String username, String password) async {
    // String url = UrlAddress.url + '/signin';
    var url = Uri.parse(UrlAddress.url + '/signin');
    final response = await retry(() => http.post(url,
        headers: {"Accept": "Application/json"},
        body: {'username': encrypt(username), 'password': encrypt(password)}));
    var convertedDatatoJson = jsonDecode(response.body);
    return convertedDatatoJson;
  }

  Future loginHepe(String username, String password) async {
    // String url = UrlAddress.url + '/signinhepe';
    var url = Uri.parse(UrlAddress.url + '/signinhepe');
    final response = await retry(() => http.post(url,
        headers: {"Accept": "Application/json"},
        body: {'username': encrypt(username), 'password': encrypt(password)}));
    var convertedDatatoJson = jsonDecode(response.body);
    return convertedDatatoJson;
  }

  Future changeSalesmanPassword(String code, String pass) async {
    // String url = UrlAddress.url + '/changesmpassword';
    var url = Uri.parse(UrlAddress.url + '/changesmpassword');
    final response = await retry(() => http.post(url,
        headers: {"Accept": "Application/json"},
        body: {'user_code': encrypt(code), 'password': encrypt(pass)}));
    var convertedDatatoJson = jsonDecode(response.body);
    return convertedDatatoJson;
  }

  Future changeHepePassword(String code, String pass) async {
    // String url = UrlAddress.url + '/changehepepassword';
    var url = Uri.parse(UrlAddress.url + '/changehepepassword');
    final response = await retry(() => http.post(url,
        headers: {"Accept": "Application/json"},
        body: {'user_code': encrypt(code), 'password': encrypt(pass)}));
    var convertedDatatoJson = jsonDecode(response.body);
    return convertedDatatoJson;
  }

  Future addSmsCode(String username, String code, String mobile) async {
    // String url = UrlAddress.url + '/addsmscode';
    var url = Uri.parse(UrlAddress.url + '/addsmscode');
    final response = await retry(() => http.post(url, headers: {
          "Accept": "Application/json"
        }, body: {
          'username': encrypt(username),
          'smscode': encrypt(code),
          'mobile': encrypt(mobile)
        }));
    var convertedDatatoJson = jsonDecode(decrypt(response.body));
    return convertedDatatoJson;
  }

  Future checkSmsCode(String username, String code) async {
    // String url = UrlAddress.url + '/checksmscode';
    var url = Uri.parse(UrlAddress.url + '/checksmscode');
    final response = await retry(() => http.post(url, headers: {
          "Accept": "Application/json"
        }, body: {
          'username': encrypt(username),
          'smscode': encrypt(code),
        }));
    var convertedDatatoJson = jsonDecode(decrypt(response.body));
    return convertedDatatoJson;
  }

  Future addHepeSmsCode(String username, String code, String mobile) async {
    // String url = UrlAddress.url + '/addhepesmscode';
    var url = Uri.parse(UrlAddress.url + '/addhepesmscode');
    final response = await retry(() => http.post(url, headers: {
          "Accept": "Application/json"
        }, body: {
          'username': encrypt(username),
          'smscode': encrypt(code),
          'mobile': encrypt(mobile)
        }));
    var convertedDatatoJson = jsonDecode(decrypt(response.body));
    return convertedDatatoJson;
  }

  Future checkHepeSmsCode(String username, String code) async {
    // String url = UrlAddress.url + '/checkhepesmscode';
    var url = Uri.parse(UrlAddress.url + '/checkhepesmscode');
    final response = await retry(() => http.post(url, headers: {
          "Accept": "Application/json"
        }, body: {
          'username': encrypt(username),
          'smscode': encrypt(code),
        }));
    var convertedDatatoJson = jsonDecode(decrypt(response.body));
    return convertedDatatoJson;
  }

  Future updateSalesmanStatus(username) async {
    var client = await db;
    String stat = '0';
    return client.update('salesman_lists', {'status': stat},
        where: 'username = ?', whereArgs: [username]);
  }

  Future updateHepeStatus(username) async {
    var client = await db;
    String stat = '0';
    return client.update('tbl_hepe_de_viaje', {'status': stat},
        where: 'username = ?', whereArgs: [username]);
  }

  Future updateSalesmanStatusOnline(String username) async {
    String stat = '0';
    // String url = UrlAddress.url + '/updatesmstatus';
    var url = Uri.parse(UrlAddress.url + '/updatesmstatus');
    final response = await retry(() => http.post(url, headers: {
          "Accept": "Application/json"
        }, body: {
          'username': encrypt(username),
          'status': encrypt(stat),
        }));
    var convertedDatatoJson = jsonDecode(decrypt(response.body));
    return convertedDatatoJson;
  }

  Future updateHepeStatusOnline(String username) async {
    String stat = '0';
    // String url = UrlAddress.url + '/updatehepestatus';
    var url = Uri.parse(UrlAddress.url + '/updatehepestatus');
    final response = await retry(() => http.post(url, headers: {
          "Accept": "Application/json"
        }, body: {
          'username': encrypt(username),
          'status': encrypt(stat),
        }));
    var convertedDatatoJson = jsonDecode(decrypt(response.body));
    return convertedDatatoJson;
  }

  Future getSMPasswordHistory(String userId, String password) async {
    // String url = UrlAddress.url + '/checksmpasshistory';
    var url = Uri.parse(UrlAddress.url + '/checksmpasshistory');
    // var passwordF = md5.convert(utf8.encode(password));
    final response = await retry(() => http.post(url, headers: {
          "Accept": "Application/json"
        }, body: {
          'account_code': encrypt(userId),
          'password': encrypt(password),
        }));
    var convertedDatatoJson = jsonDecode(decrypt(response.body));
    return convertedDatatoJson;
  }

  Future getHEPEPasswordHistory(String userId, String password) async {
    // String url = UrlAddress.url + '/checkhepepasshistory';
    var url = Uri.parse(UrlAddress.url + '/checkhepepasshistory');
    // var passwordF = md5.convert(utf8.encode(password));
    final response = await retry(() => http.post(url, headers: {
          "Accept": "Application/json"
        }, body: {
          'account_code': encrypt(userId),
          'password': encrypt(password),
        }));
    var convertedDatatoJson = jsonDecode(decrypt(response.body));
    return convertedDatatoJson;
  }

  Future setLoginDevice(String code, String device) async {
    // String url = UrlAddress.url + '/setlogindevice';
    var url = Uri.parse(UrlAddress.url + '/setlogindevice');
    // var passwordF = md5.convert(utf8.encode(password));
    final response = await retry(() => http.post(url,
        headers: {"Accept": "Application/json"},
        body: {'account_code': encrypt(code), 'device': encrypt(device)}));
    var convertedDatatoJson = jsonDecode(decrypt(response.body));
    return convertedDatatoJson;
  }

  Future checkLoginDevice(String code, String device) async {
    // String url = UrlAddress.url + '/checklogindevice';
    var url = Uri.parse(UrlAddress.url + '/checklogindevice');
    // var passwordF = md5.convert(utf8.encode(password));
    final response = await retry(() => http.post(url,
        headers: {"Accept": "Application/json"},
        body: {'account_code': code, 'device': device}));
    var convertedDatatoJson = jsonDecode(response.body);
    return convertedDatatoJson;
  }

  Future checkCustomerMessages(code) async {
    // String url = UrlAddress.url + '/checkcustomermessage';
    var url = Uri.parse(UrlAddress.url + '/checkcustomermessage');
    // var passwordF = md5.convert(utf8.encode(password));
    final response = await retry(() => http.post(url,
        headers: {"Accept": "Application/json"}, body: {'account_code': code}));
    var convertedDatatoJson = jsonDecode(response.body);
    return convertedDatatoJson;
  }

  Future getMessageHead(code) async {
    // String url = UrlAddress.url + '/getallmessagehead';
    var url = Uri.parse(UrlAddress.url + '/getallmessagehead');
    // var passwordF = md5.convert(utf8.encode(password));
    final response = await retry(() => http.post(url,
        headers: {"Accept": "Application/json"},
        body: {'account_code': encrypt(code)}));
    var convertedDatatoJson = jsonDecode(decrypt(response.body));
    return convertedDatatoJson;
  }

  Future getMessage(ref) async {
    // String url = UrlAddress.url + '/getmessage';
    var url = Uri.parse(UrlAddress.url + '/getmessage');
    // var passwordF = md5.convert(utf8.encode(password));
    final response = await retry(() => http.post(url,
        headers: {"Accept": "Application/json"},
        body: {'ref_no': encrypt(ref)}));
    var convertedDatatoJson = jsonDecode(decrypt(response.body));
    return convertedDatatoJson;
  }

  Future sendMsg(code, ref, msg) async {
    // String url = UrlAddress.url + '/addreply';
    var url = Uri.parse(UrlAddress.url + '/addreply');
    // var passwordF = md5.convert(utf8.encode(password));
    final response = await retry(() => http.post(url, headers: {
          "Accept": "Application/json"
        }, body: {
          'account_code': encrypt(code),
          'ref_no': encrypt(ref),
          'msg_body': encrypt(msg)
        }));
    var convertedDatatoJson = jsonDecode(decrypt(response.body));
    return convertedDatatoJson;
  }

  Future changeMsgStat(ref) async {
    // String url = UrlAddress.url + '/changemsgstat';
    var url = Uri.parse(UrlAddress.url + '/changemsgstat');
    // var passwordF = md5.convert(utf8.encode(password));
    final response = await retry(() => http.post(url,
        headers: {"Accept": "Application/json"},
        body: {'ref_no': encrypt(ref)}));
    var convertedDatatoJson = jsonDecode(decrypt(response.body));
    return convertedDatatoJson;
  }

  Future checkAppversion(tvar) async {
    var url = Uri.parse(UrlAddress.url + '/checkappversion');
    // var passwordF = md5.convert(utf8.encode(password));
    final response = await retry(() => http.post(url,
        headers: {"Accept": "Application/json"},
        body: {'tvar': encrypt(tvar)}));
    var convertedDatatoJson = jsonDecode(decrypt(response.body));
    return convertedDatatoJson;
  }

  Future getAllMessageLog() async {
    // String url = UrlAddress.url + '/getallmessagehead';
    var url = Uri.parse(UrlAddress.url + '/getallmessageheadlog');
    // var passwordF = md5.convert(utf8.encode(password));
    final response = await retry(() =>
        http.post(url, headers: {"Accept": "Application/json"}, body: {}));
    var convertedDatatoJson = jsonDecode(decrypt(response.body));
    return convertedDatatoJson;
  }

  Future updateSalesmanImg(String code, String img) async {
    // String url = UrlAddress.url + '/updatehepestatus';
    var url = Uri.parse(UrlAddress.url + '/updatesmimage');
    final response = await retry(() => http.post(url, headers: {
          "Accept": "Application/json"
        }, body: {
          'user_code': encrypt(code),
          'img': encrypt(img),
        }));
    var convertedDatatoJson = jsonDecode(decrypt(response.body));
    return convertedDatatoJson;
  }

  Future updateHepeImg(String code, String img) async {
    // String url = UrlAddress.url + '/updatehepestatus';
    var url = Uri.parse(UrlAddress.url + '/updatehepeimage');
    final response = await retry(() => http.post(url, headers: {
          "Accept": "Application/json"
        }, body: {
          'user_code': encrypt(code),
          'img': encrypt(img),
        }));
    var convertedDatatoJson = jsonDecode(decrypt(response.body));
    return convertedDatatoJson;
  }
}
