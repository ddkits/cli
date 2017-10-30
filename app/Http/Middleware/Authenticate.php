<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Support\Facades\Auth;

class Authenticate
{
    /**
     * Handle an incoming request.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  \Closure  $next
     * @param  string|null  $guard
     * @return mixed
     */
    public function handle($request, Closure $next, $guard = null)
    {

        // If user is not logged in deny ajax requests and redirect to login
        // on web ui
        if (Auth::guard($guard)->guest()) {
            if ($request->ajax()) {
                return response('Unauthorized.', 401);
            } else {
                return redirect()->guest('login');
            }
        }

        // If user is logged in and does not have is_lead_analyst then redirect
        // to a page that indicates the user does not have the proper permissions

        $auth0User = \Auth::user();
        $auth0UserInfo = $auth0User->getUserInfo();
        if (!$auth0UserInfo['app_metadata']['is_lead_analyst']) {
            if ($request->ajax()) {
                return response('Unauthorized.', 401);
            } else {
                return response()->view('unauthorized')->setStatusCode(401);
            }
        }

        return $next($request);
    }
}
