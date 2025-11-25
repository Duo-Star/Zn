// compound : n.混合物，化合物；复合词；
// 指列表和向量这两种量：复合量
// <> []
import "../lib.dart" as lib;

/*
@ bool 是否是复合量
@ String 类型 vector/map
@ String 值列
*/
(bool, String, String) checkCompound(String code) {
  String first = lib.findFirstNotBlankSign(code);
  if (!(first == '<' || first == '[')) return (false, '', '');
  List<dynamic> pairInfo = lib.findPair(code, first, first == '<' ? '>' : ']');
  if (!pairInfo[0]) return (false, '', '');
  String after = code.substring(pairInfo[3]);
  if (after.trim() != '') return (false, '', '');
  return (
    true,
    first == '<' ? 'vector' : 'map',
    code.substring(pairInfo[2] + 1, pairInfo[3] - 1),
  );
}
