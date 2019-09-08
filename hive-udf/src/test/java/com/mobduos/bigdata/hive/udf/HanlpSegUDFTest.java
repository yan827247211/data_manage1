package com.mobduos.bigdata.hive.udf;

import com.hankcs.hanlp.HanLP;
import com.hankcs.hanlp.seg.Segment;
import org.apache.hadoop.hive.ql.exec.UDFArgumentException;
import org.apache.hadoop.hive.ql.metadata.HiveException;
import org.apache.hadoop.hive.ql.udf.generic.GenericUDF;
import org.apache.hadoop.hive.serde2.objectinspector.ObjectInspector;
import org.apache.hadoop.hive.serde2.objectinspector.primitive.PrimitiveObjectInspectorFactory;
import org.apache.hadoop.io.Text;

import java.io.File;


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

        GenericUDF.DeferredObject valueObj = new GenericUDF.DeferredJavaObject(new Text("今天天气不错,风和日丽的,我早早的来到抖音看小哥哥小姐姐比心[鲜花][呲牙][玫瑰]"));
        GenericUDF.DeferredObject[] argument = {valueObj};
        System.out.println(hanlpSegUDF.evaluate(argument));
    }

//    public static void main(String[] args) throws HiveException {
//        HanlpSegUDFTest test = new HanlpSegUDFTest();
//        test.testHanlpSeg();
//    }

    public static void main(String[] args) {
        Segment segment = HanLP.newSegment().enableNameRecognize(true)
                .enableAllNamedEntityRecognize(true)
                .enableOrganizationRecognize(false)   // 解决句末标点符号对分词的影响
                .enableCustomDictionary(true);
//        System.out.println(new File("data/dictionary/CoreNatureDictionary.mini.txt.bin").getAbsolutePath());
        System.out.println(segment.seg("今天天气不错,风和日丽的,去抖音看小哥哥小姐姐比心[鲜花][呲牙][玫瑰]"));
    }
}
