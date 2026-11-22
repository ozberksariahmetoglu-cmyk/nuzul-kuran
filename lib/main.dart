import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:shared_preferences/shared_preferences.dart';

const ink = Color(0xFF183B32);
const gold = Color(0xFFB18A45);
const paper = Color(0xFFF6F1E6);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const NuzulApp());
}

class NuzulApp extends StatefulWidget {
  const NuzulApp({super.key});
  @override
  State<NuzulApp> createState() => _NuzulAppState();
}

class _NuzulAppState extends State<NuzulApp> {
  bool dark = false;
  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Nüzul',
    theme: ThemeData(useMaterial3: true, colorScheme: ColorScheme.fromSeed(seedColor: ink, brightness: Brightness.light), scaffoldBackgroundColor: paper, appBarTheme: const AppBarTheme(backgroundColor: paper, foregroundColor: ink), cardTheme: CardThemeData(color: Colors.white, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18), side: const BorderSide(color: Color(0xFFE6DDCB)))), fontFamily: 'serif'),
    darkTheme: ThemeData(useMaterial3: true, colorScheme: ColorScheme.fromSeed(seedColor: ink, brightness: Brightness.dark), fontFamily: 'serif'),
    themeMode: dark ? ThemeMode.dark : ThemeMode.light,
    home: HomePage(onTheme: () => setState(() => dark = !dark), dark: dark),
  );
}

class HomePage extends StatefulWidget {
  final VoidCallback onTheme; final bool dark;
  const HomePage({super.key, required this.onTheme, required this.dark});
  @override State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int tab = 0;
  List<Map<String,dynamic>> surahs = [];
  @override void initState() { super.initState(); _load(); }
  Future<void> _load() async {
    final raw = await rootBundle.loadString('assets/data/surahs.json');
    setState(() => surahs = List<Map<String,dynamic>>.from(jsonDecode(raw)));
  }
  @override Widget build(BuildContext context) {
    final pages = [home(), SurahPage(surahs: surahs), const SearchPage(), const SavedPage()];
    return Scaffold(body: SafeArea(child: pages[tab]), bottomNavigationBar: NavigationBar(selectedIndex: tab, onDestinationSelected: (v)=>setState(()=>tab=v), destinations: const [NavigationDestination(icon: Icon(Icons.home_outlined),label:'Ana sayfa'),NavigationDestination(icon: Icon(Icons.menu_book_outlined),label:'Sureler'),NavigationDestination(icon: Icon(Icons.search),label:'Ara'),NavigationDestination(icon: Icon(Icons.bookmark_border),label:'Kaydedilenler') ]));
  }
  Widget home() => CustomScrollView(slivers: [
    SliverToBoxAdapter(child: Padding(padding: const EdgeInsets.fromLTRB(22,20,22,8), child: Row(children:[const Icon(Icons.auto_stories, color:gold,size:30),const SizedBox(width:10),const Text('NÜZUL',style:TextStyle(fontSize:24,fontWeight:FontWeight.bold,letterSpacing:3,color:ink)),const Spacer(),IconButton(onPressed:widget.onTheme,icon:Icon(widget.dark?Icons.light_mode:Icons.dark_mode))]))),
    SliverToBoxAdapter(child: Padding(padding: const EdgeInsets.all(18),child: Container(padding: const EdgeInsets.all(24),decoration:BoxDecoration(color:ink,borderRadius:BorderRadius.circular(24),gradient:const LinearGradient(colors:[Color(0xFF183B32),Color(0xFF28594A)],begin:Alignment.topLeft,end:Alignment.bottomRight)),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[const Text('YAŞAYAN KUR’AN',style:TextStyle(color:Color(0xFFE5C58B),letterSpacing:2,fontSize:12)),const SizedBox(height:12),const Text('Oku. Anla. Hayata taşı.',style:TextStyle(color:Colors.white,fontSize:25,fontWeight:FontWeight.w600)),const SizedBox(height:8),Text('R. İhsan Eliaçık’ın Türkçe meal-tefsir çalışması',style:TextStyle(color:Colors.white.withOpacity(.8),fontSize:14)),const SizedBox(height:22),FilledButton.icon(style:FilledButton.styleFrom(backgroundColor:const Color(0xFFE5C58B),foregroundColor:ink),onPressed:()=>Navigator.push(context,MaterialPageRoute(builder:(_)=>const ReaderPage())),icon:const Icon(Icons.menu_book),label:const Text('Okumaya başla'))]))),
    SliverToBoxAdapter(child: Padding(padding:const EdgeInsets.fromLTRB(22,4,22,10),child:const Text('Kütüphane',style:TextStyle(fontSize:21,fontWeight:FontWeight.bold,color:ink)))),
    SliverPadding(padding:const EdgeInsets.symmetric(horizontal:16),sliver:SliverGrid.count(crossAxisCount:2,mainAxisSpacing:10,crossAxisSpacing:10,childAspectRatio:1.55,children:[_tile(Icons.format_list_numbered,'Nüzul sırası','Sureleri sırayla keşfet',()=>setState(()=>tab=1)),_tile(Icons.search,'Metinde ara','Kelime ve ifadeleri bul',()=>setState(()=>tab=2)),_tile(Icons.bookmark,'Yer imleri','Kaldığın yerlere dön',()=>setState(()=>tab=3)),_tile(Icons.auto_awesome,'Günün ayeti','Günlük okuma alanı',()=>Navigator.push(context,MaterialPageRoute(builder:(_)=>const ReaderPage()))) ])),
    SliverToBoxAdapter(child:Padding(padding:const EdgeInsets.all(22),child:Text('Kaynak eser PDF olarak uygulamanın içinde bulunur. İnternet bağlantısı olmadan okunabilir.',style:TextStyle(color:ink.withOpacity(.7),fontSize:13))))
  ]);
  Widget _tile(IconData icon,String title,String sub,VoidCallback action)=>Card(child:InkWell(borderRadius:BorderRadius.circular(18),onTap:action,child:Padding(padding:const EdgeInsets.all(14),child:Column(crossAxisAlignment:CrossAxisAlignment.start,mainAxisAlignment:MainAxisAlignment.center,children:[Icon(icon,color:gold,size:25),const SizedBox(height:8),Text(title,style:const TextStyle(fontWeight:FontWeight.bold,fontSize:16,color:ink)),Text(sub,style:TextStyle(fontSize:11,color:ink.withOpacity(.65)))]))));
}

class ReaderPage extends StatelessWidget { const ReaderPage({super.key}); @override Widget build(BuildContext context)=>Scaffold(appBar:AppBar(title:const Text('Yaşayan Kur’an')),body:const PdfViewer.asset('assets/yasayan_kuran.pdf')); }

class SurahPage extends StatelessWidget {
 final List<Map<String,dynamic>> surahs; const SurahPage({super.key,required this.surahs});
 @override Widget build(BuildContext context)=>Scaffold(appBar:AppBar(title:const Text('Nüzul sırasına göre sureler')),body:surahs.isEmpty?const Center(child:CircularProgressIndicator()):Column(children:[const Padding(padding:EdgeInsets.all(14),child:Text('Bu liste PDF başlıklarından otomatik çıkarılmıştır; doğrulanmamış eksik kayıtlar bulunabilir.',style:TextStyle(fontSize:12))),Expanded(child:ListView.separated(itemCount:surahs.length,separatorBuilder:(_,__)=>const Divider(height:1,indent:18,endIndent:18),itemBuilder:(context,i){final s=surahs[i];return ListTile(leading:CircleAvatar(backgroundColor:ink,foregroundColor:Colors.white,child:Text('${s['order']}')),title:Text('${s['name']} Suresi',style:const TextStyle(fontWeight:FontWeight.w600)),subtitle:Text('Kur’an sırası: ${s['number']}  •  PDF sayfası: ${s['page']}'),trailing:const Icon(Icons.chevron_right),onTap:()=>Navigator.push(context,MaterialPageRoute(builder:(_)=>const ReaderPage())));} ))]));
}

class SearchPage extends StatefulWidget { const SearchPage({super.key}); @override State<SearchPage> createState()=>_SearchPageState(); }
class _SearchPageState extends State<SearchPage>{ final c=TextEditingController(); String text=''; bool loading=false; List<String> results=[];
 Future<void> search(String q) async { if(q.trim().isEmpty){setState(()=>results=[]);return;} setState(()=>loading=true); final all=await rootBundle.loadString('assets/data/book.txt'); final lines=all.split('\n'); final found=<String>[]; for(var i=0;i<lines.length;i++){if(lines[i].toLowerCase().contains(q.toLowerCase())){final snippet=lines.skip(i>1?i-1:0).take(3).join(' ').trim();if(snippet.isNotEmpty)found.add(snippet);if(found.length>=100)break;}} setState(() { results = found; loading = false; }); }
 @override Widget build(BuildContext context)=>Scaffold(appBar:AppBar(title:const Text('Kitapta ara')),body:Column(children:[Padding(padding:const EdgeInsets.all(16),child:TextField(controller:c,onChanged:search,decoration:InputDecoration(hintText:'Kelime veya ifade yazın',prefixIcon:const Icon(Icons.search),filled:true,border:OutlineInputBorder(borderRadius:BorderRadius.circular(16),borderSide:BorderSide.none)))),if(loading)const LinearProgressIndicator(),Expanded(child:results.isEmpty?const Center(child:Text('Aramak istediğiniz kelimeyi yazın.')):ListView.builder(itemCount:results.length,itemBuilder:(_,i)=>ListTile(title:Text(results[i]),leading:const Icon(Icons.article_outlined,color:gold),onTap:()=>Navigator.push(context,MaterialPageRoute(builder:(_)=>const ReaderPage())))))])); }

class SavedPage extends StatefulWidget { const SavedPage({super.key}); @override State<SavedPage> createState()=>_SavedPageState(); }
class _SavedPageState extends State<SavedPage>{ final note=TextEditingController(); List<String> notes=[]; @override void initState(){super.initState();_load();} Future<void> _load()async{final p=await SharedPreferences.getInstance();setState(()=>notes=p.getStringList('notes')??[]);} Future<void> _add()async{if(note.text.trim().isEmpty)return;final p=await SharedPreferences.getInstance();notes=[...notes,note.text.trim()];await p.setStringList('notes',notes);note.clear();setState((){});} @override Widget build(BuildContext context)=>Scaffold(appBar:AppBar(title:const Text('Notlarım ve kayıtlarım')),body:Column(children:[Padding(padding:const EdgeInsets.all(16),child:Row(children:[Expanded(child:TextField(controller:note,decoration:const InputDecoration(hintText:'Kişisel not ekle'))),IconButton(onPressed:_add,icon:const Icon(Icons.add_circle,color:gold,size:30))])),Expanded(child:notes.isEmpty?const Center(child:Text('Henüz not eklenmedi.')):ListView.builder(itemCount:notes.length,itemBuilder:(_,i)=>ListTile(leading:const Icon(Icons.sticky_note_2_outlined),title:Text(notes[i]),trailing:IconButton(icon:const Icon(Icons.delete_outline),onPressed:()async{notes.removeAt(i);final p=await SharedPreferences.getInstance();await p.setStringList('notes',notes);setState((){});}))))])); }
