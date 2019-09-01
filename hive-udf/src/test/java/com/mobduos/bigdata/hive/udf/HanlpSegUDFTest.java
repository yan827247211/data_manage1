package com.mobduos.bigdata.hive.udf;

import org.apache.hadoop.hive.ql.exec.UDFArgumentException;
import org.apache.hadoop.hive.ql.metadata.HiveException;
import org.apache.hadoop.hive.ql.udf.generic.GenericUDF;
import org.apache.hadoop.hive.serde2.objectinspector.ObjectInspector;
import org.apache.hadoop.hive.serde2.objectinspector.primitive.PrimitiveObjectInspectorFactory;
import org.apache.hadoop.io.Text;

/**
 * @author: YuLei
 * @create: 2019-09-01 17:01
 * @description:
 **/
public class HanlpSegUDFTest {

    public void testHanlpSeg() throws HiveException {
        HanlpSegUDF hanlpSegUDF = new HanlpSegUDF();
        ObjectInspector valueOI0 = PrimitiveObjectInspectorFactory.javaStringObjectInspector;
        ObjectInspector[] arguments = {valueOI0};
        hanlpSegUDF.initialize(arguments);

        GenericUDF.DeferredObject valueObj = new GenericUDF.DeferredJavaObject(new Text("今天天气不错,风和日丽的"));
        GenericUDF.DeferredObject[] argument = {valueObj};
        System.out.println(hanlpSegUDF.evaluate(argument));
    }
}
