package com.anany.azkar

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetProvider

class DhikrWidgetProvider : HomeWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences,
    ) {
        appWidgetIds.forEach { widgetId ->
            val views = RemoteViews(context.packageName, R.layout.dhikr_widget).apply {
                val text = widgetData.getString("dhikr_text", "سبحان الله") ?: "سبحان الله"
                val count = widgetData.getInt("dhikr_count", 0)
                setTextViewText(R.id.dhikr_text, text)
                setTextViewText(R.id.dhikr_count, count.toString())
                val pendingIntent = HomeWidgetLaunchIntent.getActivity(
                    context,
                    MainActivity::class.java,
                    android.net.Uri.parse("muslimlife://increment"),
                )
                setOnClickPendingIntent(R.id.dhikr_widget_root, pendingIntent)
            }
            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }
}
