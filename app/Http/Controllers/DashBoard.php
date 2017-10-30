<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\User;
use App\Http\Controllers\Controller;
use App\Http\Controllers\AdminCont;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Validator;
use Illuminate\Foundation\Auth\AuthenticatesUsers;
use Illuminate\Foundation\Auth\RegistersUsers;
use Illuminate\Support\Facades\Auth;
use Session;

class DashBoard extends Controller
{
	
    protected function getDash(){
    	$userId = Auth::user()->id;
    	// admin or not
    	$admin = 0;
        $myFriends = [];
        $myPostsViews = 0;
        $myPostViews =[];
        $myPostsChart =[];
        $postComments = [];
        $postCommentsCount = [];
        $countv=0;
        $countp=0;
    	$user = DB::table('admins')->where('uid', $userId)->first();
		if ($user !== null) {
		   $admin = 1;
		}
    	// Get the User Blogs
    	$posts = DB::table('posts')->get();
    	$postsCount = DB::table('posts')->count();
    	// Get the User comments
    	$comments = DB::table('comments')->where('uid', $userId)->get();
    	$commentsCount = DB::table('comments')->where('uid', $userId)->count();
        // Get the User Blogs, folowers and friends
        $friendsIds = DB::table('friends')->where('uid1', $userId)->get();
        if ($friendsIds) {
            foreach ($friendsIds as $friend) {
                $id = $friend->uid2;
                $myFriends = DB::table('users')->where('uid', $id);
            }
        }
        // get my posts only
        $myPosts = DB::table('posts')->where('uid', $userId)->get();
        foreach ($myPosts as $post) {
            $existViews = DB::table('views')->where('nid', $post->id)->first();
                $countv = $countv + $existViews->views;
                $myPostsViews = $countv;
                $myPostViews[$post->id] = $existViews->views;
        } 

        // comments for each blogs
        foreach ($myPosts as $myPost) {
            $postComments[$myPost->id] = DB::table('comments')->where('nid', $myPost->id)->get();
            $postCommentsCount[$myPost->id] = DB::table('comments')->where('nid', $myPost->id)->count();
        }
        
        // Get views for each one of the posts
        foreach ($myPosts as $myPost) {
            $views = DB::table('views')->where('nid', $myPost->id)->first();
            $myViewsChart[$myPost->title] = $views->views;
        }

        // Get posts in order of dates
        $myPostsCharts = DB::table('posts')->where('uid', $userId)->get();
        foreach ($myPostsCharts as $post) {
            $pdate = date("M-Y", strtotime($post->created_at));
                if (!empty($myPostsChart[$pdate])) {
                    $countp = $myPostsChart[$pdate]['count'] + 1;
                    $day = date('j', strtotime($post->created_at));
                    $myPostsChart[$pdate] = array('month'=> $pdate,  'day' => $day, 'count' => $countp );
                }else{
                    $countp = 1;
                    $day = date('j', strtotime($post->created_at));
                    $myPostsChart[$pdate] = array('month'=> $pdate , 'day' => $day, 'count' => $countp );
                }
                
                
        }

        $myFriendsCount = DB::table('friends')->where('uid1', $userId)->count();
        $myFollowersCount = DB::table('followers')->where('who', $userId)->count();
        
        // Get all views happend to any user blog
        $myViews = DB::table('posts')->where('uid', $userId)->first();


        return view('pages.dashboard')->withAdmin($admin)->withComments($comments)->withPostsc($postsCount)->withCommentsc($commentsCount)->withFollowersc($myFollowersCount)->withFriendsc($myFriendsCount)->with([
            'Posts'=>$posts, 
            'Friends' => $myFriends, 
            'myPosts'=>$myPosts, 
            'myPostsViews' => $myPostsViews, 
            'myPostViews' => $myPostViews,
            'postComments' => $postComments,
            'postCommentsCount' => $postCommentsCount,
            'myViewsChart' => $myViewsChart,
            'myPostsChart' => $myPostsChart,
            'myPostsCharts' => $myPostsCharts,
            ]);
    }
    public function postDash(){
        return view('pages.dashboard');
    }

    public function postComments($nid){
            
        return;
    }

}
