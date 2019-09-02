package com.mobduos.bigdata.hive.udf;

import com.hankcs.hanlp.HanLP;
import com.hankcs.hanlp.corpus.tag.Nature;
import com.hankcs.hanlp.dictionary.stopword.CoreStopWordDictionary;
import com.hankcs.hanlp.seg.Segment;
import com.hankcs.hanlp.seg.common.Term;
import org.apache.hadoop.hive.ql.exec.Description;
import org.apache.hadoop.hive.ql.exec.UDFArgumentException;
import org.apache.hadoop.hive.ql.exec.UDFArgumentLengthException;
import org.apache.hadoop.hive.ql.metadata.HiveException;
import org.apache.hadoop.hive.ql.udf.generic.GenericUDF;
import org.apache.hadoop.hive.serde2.objectinspector.ObjectInspector;
import org.apache.hadoop.hive.serde2.objectinspector.ObjectInspectorConverters;
import org.apache.hadoop.hive.serde2.objectinspector.ObjectInspectorFactory;
import org.apache.hadoop.hive.serde2.objectinspector.primitive.PrimitiveObjectInspectorFactory;
import org.apache.hadoop.io.Text;

import java.util.ArrayList;
import java.util.List;

/**
 * @author: YuLei
 * @create: 2019-08-31 21:32
 * @description: 利用Hanlp分词库对文本进行分词
 **/
@Description(name = "hanlpSeg", value = "_FUNC_(str) - tokenize chinese sentence "
        + "regex", extended = "Example:\n"
        + "  > SELECT _FUNC_('今天天气不错') FROM src LIMIT 1;\n"
        + "  [\"今天\", \"天气\", \"不错\"]")
public class HanlpSegUDF extends GenericUDF {
    private transient ObjectInspectorConverters.Converter converter;
    private static Segment segment = HanLP.newSegment()
            .enableAllNamedEntityRecognize(true)
            .enableCustomDictionary(true);

    @Override
    public ObjectInspector initialize(ObjectInspector[] arguments) throws UDFArgumentException {
        if (arguments.length != 1) {
            throw new UDFArgumentLengthException(
                    "hanlpSeg requires 1 argument, got \" + arguments.length.");
        }

        if (arguments[0].getCategory() != ObjectInspector.Category.PRIMITIVE) {
            throw new UDFArgumentException(
                    "LOWER only takes primitive types, got " + arguments[0].getTypeName());
        }

        converter = ObjectInspectorConverters.getConverter(arguments[0],
                PrimitiveObjectInspectorFactory.writableStringObjectInspector);

        return ObjectInspectorFactory
                .getStandardListObjectInspector(PrimitiveObjectInspectorFactory
                        .writableStringObjectInspector);
    }

    @Override
    public Object evaluate(DeferredObject[] arguments) throws HiveException {
        assert (arguments.length == 1);

        if (arguments[0].get() == null) {
            return null;
        }

        Text s = (Text) converter.convert(arguments[0].get());
        String inputStr = s.toString();
        ArrayList<Text> result = new ArrayList<Text>();
        if (inputStr != null && inputStr.trim().length() > 0) {
            List<Term> tokens = segment.seg(inputStr);
            if(tokens!=null && tokens.size()>0) {
                for (Term term : tokens) {
                    if(!CoreStopWordDictionary.contains(term.word) && !term.nature.equals(Nature.w)) {
                        result.add(new Text(term.word));
                    }
                }
            }
        }
        return result;
    }

    @Override
    public String getDisplayString(String[] children) {
        assert (children.length == 2);
        return getStandardDisplayString("hanlpSeg", children);
    }

}
