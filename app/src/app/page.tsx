'use client'

import TopBar from "../components/TopBar";
import { ConnectButton } from "../components/ConnectButton";
import { InfoList } from "../components/InfoList";
import { ActionButtonList } from "../components/ActionButtonList";
import { OnChainTxButton } from "../components/OnChainTxButton";
import {
  Button,
  Field,
  Fieldset,
  Input,
  Label,
  Legend,
  Textarea,
} from '@headlessui/react'
import clsx from 'clsx'
import Link from 'next/link'

export default function Home() {
  return (
    <>
      <div className="min-h-screen flex flex-col bg-gradient-to-br from-blue-50 via-white to-purple-50 dark:from-gray-900 dark:via-gray-800 dark:to-purple-900">
        <TopBar />
        
        <div className="flex-grow flex items-center justify-center p-4">
          <Fieldset className="rounded-2xl bg-white/80 dark:bg-gray-900/50 backdrop-blur-2xl p-8 shadow-xl border border-white/20 dark:border-gray-700/30 w-full max-w-md">
            <Legend className="text-3xl font-bold mb-8 text-center bg-gradient-to-r from-blue-600 to-purple-600 bg-clip-text text-transparent">
              ZK Travel History
            </Legend>
            
            <div className="space-y-6">
              <Field>
                <Label className="text-sm font-medium text-gray-700 dark:text-gray-300">
                  Travel Destination
                </Label>
                <Input
                  className={clsx(
                    'mt-2 block w-full rounded-lg border-0 bg-gray-50/50 dark:bg-gray-800/50 py-3 px-4 text-sm text-gray-900 dark:text-white placeholder-gray-500 dark:placeholder-gray-400',
                    'focus:ring-2 focus:ring-blue-500 dark:focus:ring-blue-400 focus:ring-offset-0 transition-all duration-200',
                    'backdrop-blur-sm border border-gray-200/50 dark:border-gray-700/50'
                  )}
                  placeholder="Enter your destination"
                />
              </Field>

              <Field>
                <Label className="text-sm font-medium text-gray-700 dark:text-gray-300">
                  Travel Date
                </Label>
                <Input
                  type="date"
                  className={clsx(
                    'mt-2 block w-full rounded-lg border-0 bg-gray-50/50 dark:bg-gray-800/50 py-3 px-4 text-sm text-gray-900 dark:text-white',
                    'focus:ring-2 focus:ring-blue-500 dark:focus:ring-blue-400 focus:ring-offset-0 transition-all duration-200',
                    'backdrop-blur-sm border border-gray-200/50 dark:border-gray-700/50'
                  )}
                />
              </Field>

              <Field>
                <Label className="text-sm font-medium text-gray-700 dark:text-gray-300">
                  Travel Notes
                </Label>
                <Textarea
                  className={clsx(
                    'mt-2 block w-full resize-none rounded-lg border-0 bg-gray-50/50 dark:bg-gray-800/50 py-3 px-4 text-sm text-gray-900 dark:text-white placeholder-gray-500 dark:placeholder-gray-400',
                    'focus:ring-2 focus:ring-blue-500 dark:focus:ring-blue-400 focus:ring-offset-0 transition-all duration-200',
                    'backdrop-blur-sm border border-gray-200/50 dark:border-gray-700/50'
                  )}
                  rows={3}
                  placeholder="Add any travel notes or details"
                />
              </Field>

              <Button
                className={clsx(
                  'w-full justify-center inline-flex items-center gap-2 rounded-lg bg-gradient-to-r from-blue-500 to-purple-600 py-3 px-4 text-sm font-semibold text-white shadow-lg',
                  'hover:from-blue-600 hover:to-purple-700 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2 dark:focus:ring-offset-gray-800',
                  'transition-all duration-200 transform hover:scale-[1.02] active:scale-[0.98]'
                )}
              >
                Generate ZK Proof
              </Button>

              <OnChainTxButton />
              <ActionButtonList />
            </div>
          </Fieldset>
        </div>

        <footer className="relative justify-center my-8 flex flex-col items-center space-y-4">
          <div className="text-xs text-gray-500 dark:text-gray-400 text-center">
            <span>&copy; 2025 ZK Travel History</span>
            <span className="mx-2">&middot;</span>
            <span>Built with ZK-SNARKs & Noir</span>
          </div>
          
          <div className="mt-6">
            <InfoList />
          </div>
        </footer>
      </div>
    </>
  );
}