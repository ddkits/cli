<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

class SettingsCont extends Controller
{

    public function getSettings(){
        return view('pages.settings');
    }
    public function postSettings(){
        return view('pages.settings');
    }

}
