<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Post;
use Illuminate\Support\Facades\DB;
use App\Comments;
use Session;
use Illuminate\Foundation\Auth\User;

class PostCont extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        // create a variable and store in it from the database 
            // $blogs = Post::all();

            $blogs = Post::orderby('id', 'desc')->paginate(10);

            return view('blog.index')->withBlogs($blogs);
        // return a view and pass in the above variable 
    }

     public function indexMe()
    {
        // create a variable and store in it from the database 
            // $blogs = Post::all();

            $blogs = DB::table('posts')->where('uid', Auth::user()->id)->orderby('id', 'desc')->get();

            return view('blog.index')->withBlogs($blogs);
        // return a view and pass in the above variable 
    }

    /**
     * Show the form for creating a new resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function create()
    {
        return view('blog.create');
    }

    /**
     * Show the form for creating a new resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function myPosts()
    {
        return;
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
            'title' => 'required|max:255',
            'body' => 'required',
            'uid' => 'required',
            ));

        // store
        $post = new Post;
        $post->title = $request->title;
        $post->body = $request->body;
        $post->uid = $request->uid;

        $post->save();

        // add views record for this post
        DB::table('views')->insert(
                ['nid' => $post->id, 'views' => 0]
            );
        Session::flash('Success', 'blog created successfully!');
        // redirect

        return redirect()->route('blog.show', $post->id);
    }

    /**
     * Display the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function show($id)
    {
        $post = Post::find($id);
        $comments = $comments = DB::table('comments')->where('nid', $id)->get();
        return view('blog.show')->withPost($post)->withComments($comments);
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
        $post = Post::find($id);
        return view('blog.edit')->withPost($post);
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
            'title' => 'required|max:255',
            'body' => 'required'
            ));

        // save the data to tthe database
        $post = Post::find($id);
        $post->title = $request->input('title');
        $post->body = $request->input('body');

        $post->save();

        // set flash data with success msg
        Session::flash('Success', 'blog updated successfully!');
        // redirect
        return redirect()->route('blog.show', $post->id);

    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function destroy($id)
    {
        Post::destroy($id);
        return redirect()->route("blog.index");
    }
}
