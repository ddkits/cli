<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use App\Comments;
use Session;
use App\Menu;


class MenuCont extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
         $menu = Menu::orderby('id', 'desc')->paginate(10);
            return view('admin.menu.index')->withMenus($menu);
    }
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function adminMenus()
    {
         $menus1 = Menu::where('menu', 'adminmenu')->get();
         foreach ($menus1 as $key) {
            if ($key['name']) {
             $menus[$key->weight] = ['id'=>$key['id'], 'name'=>$key['name']];
             }
         }
         krsort($menus);
         foreach( $menus as $menu ){
            if( $menu['menu'] == 'adminmenu')
            if ($menu['name']) {
              $adminMenus[$menu['id']] = $menu['name'];
          }
      }
            return $adminMenus;
    }

    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function mainMenus()
    {
         $menus1 = Menu::where('menu', 'mainmenu')->get();
         foreach ($menus1 as $key) {
            if ($key['name']) {
             $menus[$key->weight] = ['id'=>$key['id'], 'name'=>$key['name']];
                }
            }
         krsort($menus);
         foreach( $menus as $menu ){
            if($menu['menu'] == 'mainmenu')
                if ($menu['name']) {
              $mainMenus[$menu['id']] = $menu['name'];
          }
      }
            return $mainMenus;
    }
    
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function indexAll()
    {
         $menus1 = Menu::all();
         foreach ($menus1 as $key) {
            if ($key['name']) {
             $menus[$key->weight] = ['id'=>$key['id'], 'name'=>$key['name']];
            }
         }
         krsort($menus);
         foreach( $menus as $menu ){
            if ($menu['name']) {
               $allMenus[$menu['id']] = $menu['name'];
            }
              
            }
            return $allMenus;
    }
    /**
     * Display a listing of the resource.
     *
     */
    public function adminMenu()
    {
        $menus = DB::table('menus')->where('menu', 'adminmenu')->get();

        return $menus;
    }
    /**
     * Display a listing of the resource.
     *
     */
    public function mainMenu()
    {
        $menus = DB::table('menus')->where('menu', 'mainmenu')->get();

        return $menus;
    }


    /**
     * Show the form for creating a new resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function create()
    {
        return view('admin.menu.create');
    }

    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(Request $request)
    {
       // validate the data
        $this->validate($request, array(
            'name' => 'required|max:255',
            'description' => 'required',
            'menu' => 'required',
            'link' => 'required',
            ));

        // store
        $menu = new Menu;
        $menu->name = $request->name;
        $menu->description = $request->description;
        $menu->menuparent = $request->menulevel;
        $menu->menu = $request->menu;
        $menu->adminlevel = $request->adminlevel;
        $menu->link = $request->link;
        $menu->class = $request->class;
        $menu->weight = $request->weight;
        $menu->iconclass = $request->iconclass;
        $menu->save();

        Session::flash('Success', 'Menu created successfully!');
        // redirect

        return redirect()->route('menu.index');
    }

    /**
     * Display the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function show($id)
    {
        return view('menu.index');
    }

    /**
     * Show the form for editing the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function edit($id)
    {
         // find the post in the database and save it in variable 
        $menu = Menu::find($id);
        return view('menu.edit')->withPost($menu);
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function update(Request $request, $id)
    {
        // validate the data
        $this->validate($request, array(
            'name' => 'required|max:255',
            'description' => 'required',
            'menu' => 'required',
            'link' => 'required',
            ));

        // store
        $menu = Menu::find($id);
        $menu->name = $request->name;
        $menu->description = $request->description;
        $menu->menuparent = $request->menuparent;
        $menu->menu = $request->menu;
        $menu->adminlevel = $request->adminlevel;
        $menu->link = $request->link;
        $menu->class = $request->class;
        $menu->weight = $request->weight;
        $menu->iconclass = $request->iconclass;
        $menu->save();

        Session::flash('Success', 'Menu created successfully!');
        // redirect

        return redirect()->route('menu.index');
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function destroy($id)
    {
         Menu::destroy($id);
        return redirect()->route("menu.index");
    }
}
