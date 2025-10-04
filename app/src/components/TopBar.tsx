'use client'

import Link from 'next/link'
import { Button } from '@headlessui/react'
import { SunIcon, MoonIcon } from '@heroicons/react/20/solid'
import { useTheme } from 'next-themes'
import { ConnectButton } from './ConnectButton'

function TopBar() {
  const { theme, setTheme } = useTheme()

  const toggleDarkMode = () => {
    if (theme === 'dark') setTheme('light')
    else setTheme('dark')
  }

  return (
    <header className="w-full shadow-sm bg-white/80 dark:bg-gray-900/80 backdrop-blur-md border-b border-gray-200/20 dark:border-gray-700/20">
      <div className="container mx-auto px-4 py-3 flex items-center justify-between max-w-6xl">
        <div className="flex items-center space-x-4">
          <Link
            href="/"
            className="flex items-center space-x-3 text-2xl font-bold text-gray-900 dark:text-white hover:text-primary dark:hover:text-primary transition-colors"
          >
            <div className="w-8 h-8 bg-gradient-to-r from-blue-500 to-purple-600 rounded-lg flex items-center justify-center text-white font-bold text-sm">
              ZK
            </div>
            <span className="hidden sm:block">ZK Travel History</span>
            <span className="sm:hidden">ZK Travel</span>
          </Link>
        </div>
        
        <div className="flex items-center space-x-2 sm:space-x-4">
          <Link
            href="https://github.com/masaun/zk-electroneum-in-noir"
            className="hidden sm:block text-sm text-gray-600 dark:text-gray-300 hover:text-gray-900 dark:hover:text-white transition-colors"
            target="_blank"
          >
            GitHub
          </Link>
          
          <Button
            onClick={toggleDarkMode}
            className="p-2 rounded-lg bg-gray-100 dark:bg-gray-800 hover:bg-gray-200 dark:hover:bg-gray-700 transition-colors"
          >
            {theme === 'light' ? (
              <MoonIcon className="w-5 h-5 text-gray-600 dark:text-gray-300" />
            ) : (
              <SunIcon className="w-5 h-5 text-gray-600 dark:text-gray-300" />
            )}
          </Button>
          
          <ConnectButton />
        </div>
      </div>
    </header>
  )
}

export default TopBar